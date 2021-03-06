require 'digest'
class User < ActiveRecord::Base
	# Password est un champs virtuel (non-représenté en base)
	attr_accessor(:password, :cv_path)

	# La liste des attributs accessibles à la modification par
	# update_attributes()
	attr_accessible(:nom, :email, :password, :password_confirmation, :poids, :poids_ideal, :taille, :fumeur, :souhaite_arreter, :dte_naissance, :cv)

	# Le chemin du fichier PDF
	cv_path = "#{Rails.root}/public/data/:id.pdf"

	# Définit le fichier PDF attaché à cet utilisateur
	has_attached_file(	:cv,
					:url => "/data/:id.pdf",
					:path => cv_path)

	# Définit le type MIME du fichier autorisé comme étant uniquement un PDF
	validates_attachment_content_type(:cv, :content_type => ['application/pdf'])

	# Expression régulière de vérification des Emails
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	# Vérifie la validité du nom:
	#	- doit être existant
	#	- doit faire au maximum 50 chars
	validates(:nom,	:presence => true,
					:length   => { :maximum => 50 }
					)

	# Vérifie la validité de l'email:
	#	- doit être existant
	#	- doit respecter le format imposé par E.R. email_regex
	#	- est insensible à la casse
	validates(:email,	:presence => true,
					:format   => { :with => email_regex },
					:uniqueness => { :case_sensitive => false }
					)

	# Le paramètre ':confirmation => true' crée automatiquement
	# l'attribut virtuel 'password_confirmation'.
	# Le paramètre ':length => { :within => 6..40 }' contraint
	# la longueur du mot de passe entre 6 et 40 caractères (inclus).
	validates(:password,	:presence => true,
						:confirmation => true,
						:length => { :within => 6..40 }
			)

	# Vérifie la validité du poids
	#	- doit être existant
	#	- doit être compris entre 0 et 600 inclus
	#	- peut seulement être un nombre entier
	validates(:poids,	:presence => true,
					:inclusion   => { :in => 0..600 },
					:numericality => { :only_integer => true }
					)

	# Vérifie la validité du poids idéal
	#	- doit être existant
	#	- doit être supérieur ou égal à 0
	#	- doit être inférieur ou égal au poids
	validates(:poids_ideal,	:presence => true,
						:numericality => {	:only_integer => true, 
										:greater_than_or_equal_to => 0,
										:less_than_or_equal_to => :poids }
						)

	# Vérifie la validité de la taille
	#	- doit être existante
	#	- doit être supérieure ou égale à 0
	#	- doit être inférieure ou égale à 300
	validates(:taille,	:presence => true,
					:numericality => {	:only_integer => true, 
									:greater_than_or_equal_to => 0,
									:less_than_or_equal_to => 300 }
						)

	# Vérifie la validité de la date de naissance
	#	- doit être existante
	#	- doit être supérieure ou égale à 1900
	#	- doit être inférieure ou égale à aujourd'hui
	validates(:dte_naissance,	:presence => true,
							:timeliness => { 
								:on_or_after => lambda { Date.new(1900, 1, 1) }, 
								:on_or_before => lambda { Date.today() }, 
								:type => :date
							}
						)

	# La fonction de callback appelée avant la sauvegarde / mise à jour
	# d'un utilisateur dans la base. Ici, le callback fait un appel à
	# la méthode encrypt_password charchée de crypter le mot de passe
	before_save(:encrypt_password)

	# Retourne true si l'utilisateur est un fumeur, retourne false sinon.
	def fumeur?()
		if !self.fumeur.nil?() && self.fumeur == true then
			return true
		end
		return false
	end

	# Retourne true si l'utilisateur souhaite arrêter de fumer, retourne false sinon.
	def souhaite_arreter?()
		if !self.souhaite_arreter.nil?() && self.souhaite_arreter == true then
			return true
		end
		return false
	end

	# Retourne true si l'utilisateur a uploadé un CV, retourne false sinon.
	def has_cv?()
		return File.exists?("#{Rails.root}/public/data/#{id}.pdf")
	end

	# Retourne true si le mot de passe passé en paramètre correspond
	# au mot de passe stocké en base.
	def has_password?(motDePasse)
		return self.encrypted_password == encrypt(motDePasse)
	end

	# Méthode d'authentification 
	def self.authenticate(mail, motDePasse)
		user = find_by_email(mail)
		if !user.nil?() && user.has_password?(motDePasse) then
			return user
		end
		return nil
	end

	# Méthode d'authentification par comparaison du sel contenu dans le cookie
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		if !user.nil?() && user.salt == cookie_salt then
			return user
		end
		return nil
	end

	# Obtient l'âge pour l'utilisateur courant en fonction de sa date de naissance
	def age()
		if !dte_naissance.nil?() then
			aujourdhui = Date.today()
			age = aujourdhui.year() - self.dte_naissance.year()
			if aujourdhui.yday() < self.dte_naissance.yday() then
				age -= 1
			end
			return age
		end
		return nil
	end

	# Obtient l'IMC s'il est calculable, nil sinon.
	def imc()
		if (	!self.poids.nil?() &&
			!self.taille.nil?() &&
			self.poids > 0 &&
			self.taille > 0 ) then
			tailleFloat = self.taille / 100.0
			return self.poids / (tailleFloat * tailleFloat)
		end
		return nil
	end

	private
		
		# La méthode appelée avant chaque sauvegarde dans la base
		# pour crypter le mot de passe
		def encrypt_password
			if new_record?() then
				self.salt = make_salt()
			end
			self.encrypted_password = encrypt(self.password)
		end

		# Cette méthode retourne la version cryptée de la chaîne de
		# caractères passée en paramètre
		def encrypt(chaine)
			return secure_hash("#{self.salt}--#{chaine}")
		end
		
		def make_salt
			return secure_hash("#{Time.now().utc()}--#{self.password}")
		end

		def secure_hash(chaine)
			return Digest::SHA2.hexdigest(chaine)
		end

end
