# encoding: utf-8

require 'spec_helper'

describe PagesController do
	render_views

	before(:each) do
		@base_title = "On the train for Rails | "
	end

  describe "GET 'home'" do

    it "devrait etre un succes" do
      get 'home'
      response.should be_success
    end

		it "devrait avoir le bon titre" do
			get 'home'
			response.should have_selector("title", :content => @base_title + "Accueil")
		end

  end


  describe "GET 'contact'" do

    it "devrait etre un succes" do
      get 'contact'
      response.should be_success
    end

		it "devrait avoir le bon titre" do
			get 'contact'
			response.should have_selector("title", :content => @base_title + "Contact")
		end

  end


	describe "GET 'about'" do

		it "devrait etre un succes" do
			get 'about'
			response.should be_success
		end

		it "devrait avoir le bon titre" do
			get 'about'
			response.should have_selector("title", :content => @base_title + "À Propos")
		end

	end


	describe "GET 'help'" do

		it "devrait etre un succes" do
			get 'help'
			response.should be_success
		end

		it "devrait avoir le bon titre" do
			get 'help'
			response.should have_selector("title", :content => @base_title + "Aide")
		end

	end


end
