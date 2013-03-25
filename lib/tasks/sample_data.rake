# encoding: utf-8

require 'faker'

namespace :db do

	desc("Peupler la base de données")
	task(:populate => :environment) do
		Rake::Task['db:reset'].invoke()
		User.create!(	:nom => "Utilisateur exemple",
					:email => "example@railstutorial.org",
					:password => "azerty",
					:password_confirmation => "azerty")
		99.times do |n|
			nom  = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password  = "azerty"
			User.create!(	:nom => nom,
						:email => email,
						:password => password,
						:password_confirmation => password)
		end
	end

end
