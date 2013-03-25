# encoding: utf-8

require 'spec_helper'

describe "Users" do

	describe "une inscription" do

		describe "ratée" do
			it "ne devrait pas créer un nouvel utilisateur" do
				lambda do
					visit(signup_path)
					fill_in("Nom", :with => "")
					fill_in("eMail", :with => "")
					fill_in("Mot de passe", :with => "")
					fill_in("Confirmation", :with => "")
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
					fill_in("eMail", :with => "john@rambo.com")
					fill_in("Mot de passe", :with => "jrambo")
					fill_in("Confirmation", :with => "jrambo")
					click_button()
					response.should(have_selector("div.flash.success", :content => "Bienvenue"))
					response.should(render_template('users/show'))
				end.should(change(User, :count).by(1))
			end
		end # Fin d'une inscription réussie

	end # Fin description d'une inscription

end