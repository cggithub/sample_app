# encoding: utf-8

require 'spec_helper'

describe UsersController do
	render_views

	before(:each) do
		@base_title = "Simple App du Tutoriel Ruby on Rails | "
	end

	describe "GET 'new'" do
		it "devrait réussir" do
			get(:new)
			response.should(be_success())
		end
		
		it "devrait avoir le bon titre" do
			get(:new)
			response.should(have_selector("title", :content => @base_title + "Inscription"))
		end

		it "devrait avoir un champ nom" do
			get(:new)
			response.should(have_selector("input[name='user[nom]'][type='text']"))
		end

		it "devrait avoir un champ email" do
			get(:new)
			response.should(have_selector("input[name='user[email]'][type='text']"))
		end

		it "devrait avoir un champ mot de passe" do
			get(:new)
			response.should(have_selector("input[name='user[password]'][type='password']"))
		end

		it "devrait avoir un champ confirmation" do
			get(:new)
			response.should(have_selector("input[name='user[password_confirmation]'][type='password']"))
		end

	end # Fin description 'new'

	describe "GET 'show'" do

		before(:each) do
			@user = Factory(:user)
		end

		it "devrait réussir" do
			get(:show, :id => @user.id)
			response.should(be_success())
		end
		
		it "devrait trouver le bon utilisateur" do
			get(:show, :id => @user.id)
			assigns(:user).should == @user
		end

		it "devrait avoir le bon titre" do
			get :show, :id => @user.id
			response.should(have_selector("title", :content => @user.nom))
		end

		it "devrait inclure le nom de l'utilisateur" do
			get :show, :id => @user.id
			response.should(have_selector("h1", :content => @user.nom))
		end

		it "devrait avoir une image de profil" do
			get :show, :id => @user.id
			response.should(have_selector("h1>img", :class => "gravatar"))
		end
	end # Fin description 'show'

	describe "GET 'edit'" do

		before(:each) do
			@user = Factory(:user)
			test_sign_in(@user)
		end

		it "devrait réussir" do
			get(:edit, :id => @user.id)
			response.should(be_success())
		end

		it "devrait avoir le bon titre" do
			get(:edit, :id => @user.id)
			response.should(have_selector("title", :content => "Édition profil"))
		end

		it "devrait avoir un lien pour changer l'image Gravatar" do
			get(:edit, :id => @user.id)
			gravatar_url = "http://gravatar.com/emails"
			response.should(have_selector("a", :href => gravatar_url, :content => "changer"))
		end
	end # Fin description 'edit'

	describe "POST 'create'" do

		describe "échec" do

			before(:each) do
				@attr = { :nom => "", :email => "", :password => "",
				:password_confirmation => "" }
			end

			it "ne devrait pas créer d'utilisateur" do
				lambda do
					post(:create, :user => @attr)
				end.should_not(change(User, :count))
			end

			it "devrait avoir le bon titre" do
				post :create, :user => @attr
				response.should(have_selector("title", :content => "Inscription"))
			end

			it "devrait rendre la page 'new'" do
				post(:create, :user => @attr)
				response.should(render_template('new'))
			end
		end # Fin description 'échec'

		describe "succès" do

			before(:each) do
				@attr = { :nom => "New User", :email => "user@example.com",
				:password => "foobar", :password_confirmation => "foobar" }
			end

			it "devrait créer un utilisateur" do
				lambda do
					post(:create, :user => @attr)
				end.should(change(User, :count).by(1))
			end

			it "devrait rediriger vers la page d'affichage de l'utilisateur" do
				post(:create, :user => @attr)
				response.should(redirect_to(user_path(assigns(:user))))
			end

			it "devrait avoir un message de bienvenue" do
				post :create, :user => @attr
				flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
			end

			it "devrait identifier l'utilisateur" do
				post :create, :user => @attr
				controller.should(be_signed_in())
			end
		end # Fin description 'succès'

	end # Fin description 'create'

	describe "PUT 'update'" do

		before(:each) do
			@user = Factory(:user)
			test_sign_in(@user)
		end

		describe "Échec" do

			before(:each) do
				@attr = { :email => "", :nom => "", :password => "", :password_confirmation => "" }
			end

			it "devrait retourner la page d'édition" do
				put(:update, :id => @user, :user => @attr)
				response.should(render_template('edit'))
			end

			it "devrait avoir le bon titre" do
				put(:update, :id => @user, :user => @attr)
				response.should(have_selector("title", :content => "Édition profil"))
			end
		end # Fin description échec update

		describe "succès" do

			before(:each) do
				@attr = { :nom => "New Name", :email => "user@example.org",
				:password => "barbaz", :password_confirmation => "barbaz" }
			end

			it "devrait modifier les caractéristiques de l'utilisateur" do
				put(:update, :id => @user, :user => @attr)
				@user.reload()
				@user.nom.should  == @attr[:nom]
				@user.email.should == @attr[:email]
			end

			it "devrait rediriger vers la page d'affichage de l'utilisateur" do
				put(:update, :id => @user, :user => @attr)
				response.should(redirect_to(user_path(@user)))
			end

			it "devrait afficher un message flash" do
				put(:update, :id => @user, :user => @attr)
				flash[:success].should =~ /actualisé/
			end
		end # Fin description succès update

	end # Fin description update

	describe "authentification des pages edit/update" do

		before(:each) do
			@user = Factory(:user)
		end

		describe "pour un utilisateur non identifié" do

			it "devrait refuser l'accès à l'action 'edit'" do
				get(:edit, :id => @user)
				response.should(redirect_to(signin_path))
			end

			it "devrait refuser l'accès à l'action 'update'" do
				put(:update, :id => @user, :user => {})
				response.should(redirect_to(signin_path))
			end
		end # Fin description Utilisateur non-identifié

		describe "pour un utilisateur identifié" do

			before(:each) do
				wrong_user = Factory(:user, :email => "user@example.net")
				test_sign_in(wrong_user)
			end

			it "devrait correspondre à l'utilisateur à éditer" do
				get(:edit, :id => @user)
				response.should(redirect_to(root_path))
			end

			it "devrait correspondre à l'utilisateur à actualiser" do
				put(:update, :id => @user, :user => {})
				response.should(redirect_to(root_path))
			end
		end # Fin description Utilisateur identifié

	end # Fin description authentification des pages edit/update

	describe "GET 'index'" do

		describe "pour un utilisateur non identifié" do

			it "devrait refuser l'accès" do
				get(:index)
				response.should(redirect_to(signin_path))
				flash[:notice].should =~ /identifier/i
			end

		end # Fin description GET index pour un utilisateur non identifié

		describe "pour un utilisateur identifié" do

			before(:each) do
				@user = test_sign_in(Factory(:user))
				second = Factory(:user, :email => "another@example.com")
				third  = Factory(:user, :email => "another@example.net")

				# Génère 31 utilisateurs différents pour ce test
				@users = [@user, second, third]
				30.times() do
					@users << Factory(:user, :email => Factory.next(:email))
				end
			end

			it "devrait réussir" do
				get(:index)
				response.should(be_success())
			end

			it "devrait avoir le bon titre" do
				get(:index)
				response.should(have_selector("title", :content => "Tous les utilisateurs"))
			end

			it "devrait avoir un élément pour chaque utilisateur" do
				get(:index)
				@users[0..2].each do |user|
					response.should(have_selector("li", :content => user.nom))
				end
			end

			it "devrait paginer les utilisateurs" do
				get(:index)
				response.should(have_selector("div.pagination"))
				response.should(have_selector("span.disabled", :content => "Previous"))
				response.should(have_selector("a", :href => "/users?page=2", :content => "2"))
				response.should(have_selector("a", :href => "/users?page=2", :content => "Next"))
			end
		end  # Fin description GET index pour un utilisateur identifié

	end # Fin description GET index

end
