# encoding: utf-8

require 'spec_helper'

describe UsersController do
	render_views

	before(:each) do
		@base_title = "Simple App du Tutoriel Ruby on Rails | "
	end

	describe "GET 'new'" do
		it "should be successful" do
			get 'new'
			response.should be_success
		end
		
		it "devrait avoir le bon titre" do
			get 'new'
			response.should(have_selector("title", :content => @base_title + "Inscription"))
		end
	end

end
