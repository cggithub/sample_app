# encoding: utf-8

require 'spec_helper'

describe "Users" do

	describe "une inscription" do

		describe "ratée" do
			it "ne devrait pas créer un nouvel utilisateur" do
				lambda do
					visit(signup_path)
					fill_in("Nom", :with => "")
					fill_in("Email", :with => "")
					fill_in("Mot de passe", :with => "")
					fill_in("Confirmation", :with => "")
					# attach_file('user_cv', fixture_file_upload('/files/test.pdf', 'application/pdf'))
					attach_file('user_cv', File.join(Rails.root, 'spec', 'fixtures/files', 'test.pdf'), 'application/pdf')
					click_button()
					response.should(render_template('users/new'))
					response.should(have_selector("div#error_explanation"))
				end.should_not(change(User, :count))
			end
		end # Fin description d'une inscription ratée

		describe "réussie" do
			it "devrait créer un nouvel utilisateur" do
				lambda do
					visit(signup_path)
					fill_in("Nom", :with => "John Rambo")
					fill_in("Email", :with => "john@rambo.com")
					fill_in("Mot de passe", :with => "jrambo")
					fill_in("Confirmation", :with => "jrambo")
					attach_file('user_cv', File.join(Rails.root, 'spec', 'fixtures/files', 'test.pdf'), 'application/pdf')
					click_button()
					response.should(have_selector("div.flash.success", :content => "Bienvenue"))
					response.should(render_template('users/show'))
				end.should(change(User, :count).by(1))
			end
		end # Fin d'une inscription réussie

	end # Fin description d'une inscription

	describe "identification/déconnexion" do

		describe "échec" do
			it "ne devrait pas identifier l'utilisateur" do
				visit(signin_path)
				fill_in("Email", :with => "")
				fill_in("Mot de passe", :with => "")
				click_button()
				response.should(have_selector("div.flash.error", :content => "invalid"))
			end
		end

		describe "succès" do
			it "devrait identifier un utilisateur puis le déconnecter" do
				user = Factory(:user)
				visit(signin_path)
				fill_in("Email", :with => user.email)
				fill_in("Mot de passe", :with => user.password)
				click_button()
				controller.should(be_signed_in())
				click_link("Déconnexion")
				controller.should_not(be_signed_in())
			end
		end
	end

end
