# encoding: utf-8
require 'spec_helper'

# Section de tests pour la validation d'un utilisateur
describe User do

	# Applique l'opération suivante avant chaque bloc de test
	before(:each) do
		@attr = { 
			:nom => "Utilisateur d'exemple",
			:email => "utilisateur@exemple.com",
			:password => "azerty",
			:password_confirmation => "azerty",
			:poids => 90,
			:poids_ideal => 86,
			:taille => 180,
			:fumeur => true,
			:souhaite_arreter => true,
			:dte_naissance => Date.new(1950, 1, 15)
		}
	end

	it "devrait créer une nouvelle instance avec des attributs valides" do
		User.create!(@attr)
	end

	it "devrait rejeter un nom vide" do
		# Crée un utilisateur au nom vide mais avec un mail valide
		# le nom vide est obtenu en faisant un merge entre la table
		# de hashage @attr et une autre table de hashage {:nom => ""}.
		# Lorsque deux clés des deux tables de hashage sont identiques,
		# seule la valeur correspondant à la clé de la seconde table
		# est conservée (ce qui explique que l'on ait le nom vide).
		utilisateur_invalide = User.new(@attr.merge(:nom => ""))
		utilisateur_invalide.should_not(be_valid())
	end

	it "devrait rejeter un email vide" do
		# Crée un utilisateur au nom valide mais avec un mail vide
		utilisateur_invalide = User.new(@attr.merge(:email => ""))
		utilisateur_invalide.should_not(be_valid())
	end

	it "devrait rejeter les noms trop longs" do
		# Crée un mot de 51 lettres composé d'une suite de 'a'
		long_nom = "a" * 51
		# Crée un utilisateur avec un nom de 51 lettres
		long_nom_user = User.new(@attr.merge(:nom => long_nom))
		long_nom_user.should_not(be_valid())
	end

	it "devrait accepter une adresse email valide" do
		adresses = %w[bob@marley.com SUPER_MAN@biere.bar.org premier.dernier@malade.jcvd]
		adresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			valid_email_user.should(be_valid())
		end
	end

	it "devrait rejeter une adresse email invalide" do
		adresses = %w[robvandam@clock,jcvd le_saigneur_des_agneaux.ogr are.you@mad.]
		adresses.each do |address|
			invalid_email_user = User.new(@attr.merge(:email => address))
			invalid_email_user.should_not(be_valid())
		end
	end

	it "devrait rejeter un email double" do
		# Place un utilisateur avec un email donné dans la BD.
		User.create!(@attr)
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not(be_valid())
	end

	it "devrait rejeter une adresse email déjà créée et dont seule la casse change" do
		# Mise en majuscule de l'email
		upcased_email = @attr[:email].upcase
		
		# Création d'un utilisateur avec l'email en majuscule
		User.create!(@attr.merge(:email => upcased_email))

		# Création d'un utilisateur avec l'email sans majuscules
		user_with_duplicate_email = User.new(@attr)

		# Le second utilisateur doît être invalide
		user_with_duplicate_email.should_not(be_valid())
	end

	# Section de tests pour la validation du mot de passe
	describe "Validations du mot de passe" do
		
		it "devrait rejeter les mots de passe vides" do
			User.new(@attr.merge({:password => "", :password_confirmation => ""})).should_not(be_valid())
		end

		it "devrait s'assurer que la confirmation de mot de passe est identique" do
			User.new(@attr.merge({:password_confirmation => "pasvalide"})).should_not(be_valid())
		end

		it "devrait rejeter les mots de passe trop courts" do
			trop_court = "a" * 5
			User.new(@attr.merge({:password => trop_court, :password_confirmation => trop_court})).should_not(be_valid())
		end

		it "devrait rejeter les mots de passe trop longs" do
			trop_long = "a" * 41
			User.new(@attr.merge({:password => trop_long, :password_confirmation => trop_long})).should_not(be_valid())
		end

	end # Fin description Validations MDP

	describe "Cryptage du mot de passe" do

		before(:each) do
			@user = User.create!(@attr)
		end

		it "devrait avoir un attribut de mot de passe crypté" do
			@user.should(respond_to(:encrypted_password))
		end

		it "devrait davoir un mot de passe crypté non-vide" do
			@user.encrypted_password.should_not(be_blank())
		end
		
		describe "Methode has_password?" do
			
			it "doit retourner true si les mots de passe sont identiques" do
				@user.has_password?(@attr[:password]).should(be_true())
			end

			it "doit retourner false si les mots de passe sont différents" do
				@user.has_password?("pasvalide").should(be_false())
			end
			
		end # Fin description Méthode has_password?

		describe "Methode authenticate" do
			
			it "devrait retourner null si l'email et le mot de passe ne correspondent pas" do
				wrong_password_user = User.authenticate(@attr[:email], "motdepassebidon")
				wrong_password_user.should(be_nil())
			end
			
			it "devrait retourner null quand un email ne correspond à aucun utilisateur" do
				nonexistent_user = User.authenticate("hello@myfriend.com", @attr[:password])
				nonexistent_user.should(be_nil())
			end
			
			it "devrait retourner l'utilisateur si email/mot de passe correspondent" do
				matching_user = User.authenticate(@attr[:email], @attr[:password])
				matching_user.should == @user
			end
			
		end # Fin description méthode authenticate

	end # Fin description Cryptage MDP

	describe "Validation du poids" do

		it "devrait être positif" do
			utilisateur_invalide = User.new(@attr.merge(:poids => -1))
			utilisateur_invalide.should_not(be_valid())
		end

		# L'homme le plus gros du monde pèse 575 kilos
		it "devrait être inférieur ou égal à 600 kilos" do
			utilisateur_invalide = User.new(@attr.merge(:poids => 601))
			utilisateur_invalide.should_not(be_valid())
		end

	end # Fin description validation du poids

	describe "Validation du poids idéal" do

		it "devrait être positif" do
			utilisateur_invalide = User.new(@attr.merge(:poids_ideal => -1))
			utilisateur_invalide.should_not(be_valid())
		end

		it "devrait être inférieur ou égal à 600 kilos" do
			utilisateur_invalide = User.new(@attr.merge(:poids_ideal => 601))
			utilisateur_invalide.should_not(be_valid())
		end

		it "devrait être inférieur au poids" do
			utilisateur_invalide = User.new(@attr.merge(:poids_ideal => 91))
			utilisateur_invalide.should_not(be_valid())
		end

	end # Fin description validation du poids idéal

	describe "Validation de la taille" do

		it "devrait être positive" do
			utilisateur_invalide = User.new(@attr.merge(:taille => -1))
			utilisateur_invalide.should_not(be_valid())
		end

		# L'homme le plus grand du monde mesurait 270 cm
		it "devrait être inférieure ou égale à 300 cm" do
			utilisateur_invalide = User.new(@attr.merge(:taille => 301))
			utilisateur_invalide.should_not(be_valid())
		end

	end # Fin description validation de la taille

	describe "méthode fumeur?" do

		it "devrait retourner true" do
			utilisateur = User.new(@attr)
			utilisateur.fumeur?.should(be_true())
		end

		it "devrait retourner false" do
			utilisateur = User.new(@attr.merge(:fumeur => false))
			utilisateur.fumeur?.should(be_false())
		end

	end # Fin description méthode fumeur?

	describe "méthode souhaite_arreter?" do

		it "devrait retourner true" do
			utilisateur = User.new(@attr)
			utilisateur.souhaite_arreter?.should(be_true())
		end

		it "devrait retourner false" do
			utilisateur = User.new(@attr.merge(:souhaite_arreter => false))
			utilisateur.souhaite_arreter?.should(be_false())
		end

	end # Fin description méthode souhaite_arreter?

	describe "validation de la date de naissance" do

		it "devrait être supérieure ou égale à 1900" do
			utilisateur_invalide = User.new(@attr.merge(:dte_naissance => Date.new(1899, 12, 31)))
			utilisateur_invalide.should_not(be_valid())
		end

		it "devrait être inférieure ou égale à la date du jour" do
			utilisateur = User.new(@attr)
			Date.today() >= utilisateur.dte_naissance
		end

	end # Fin description validation de la date de naissance

	describe "méthode age()" do

		it "devrait retourner nil lorsque la date de naissance est nulle" do
			utilisateur = User.new(@attr.merge(:dte_naissance => nil))
			utilisateur.age().should(be_nil())
		end

		it "devrait retourner 0 lorsque la date de naissance est supérieure ou égale au jour d'aujourd'hui" do
			utilisateur = User.new(@attr.merge(:dte_naissance => Date.today()))
			utilisateur.age().should() == 0
		end

		it "devrait retourner un nombre" do
			utilisateur = User.new(@attr)
			utilisateur.age().should(be_kind_of(Numeric))
		end

	end # Fin description méthode age()

	describe "méthode imc()" do

		it "devrait retourner nil lorsque le poid vaut 0" do
			utilisateur = User.new(@attr.merge(:poids => 0))
			utilisateur.imc().should(be_nil())
		end

		it "devrait retourner nil lorsque la taille vaut 0" do
			utilisateur = User.new(@attr.merge(:taille => 0))
			utilisateur.imc().should(be_nil())
		end

		it "devrait retourner un nombre lorsque le poids et la taille sont supérieurs à 0" do
			utilisateur = User.new(@attr)
			utilisateur.imc().should(be_kind_of(Numeric))
		end

	end # Fin description méthode imc()

end # Fin description User
