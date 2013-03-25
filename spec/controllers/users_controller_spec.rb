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
		end # Fin description 'succès'

	end # Fin description 'create'

end
