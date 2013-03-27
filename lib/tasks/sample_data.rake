# encoding: utf-8

require 'faker'

namespace :db do

	desc("Peupler la base de données")

	task(:populate => :environment) do
		Rake::Task['db:reset'].invoke()
		User.create!(	:nom => "Clément GUILLERMIN",
					:email => "clement.guillermin@univ-angers.fr",
					:password => "azerty",
					:password_confirmation => "azerty",
					:poids => 70,
					:poids_ideal => 68,
					:taille => 179,
					:dte_naissance => Date.new(1991, 3, 31),
					:fumeur => false,
					:souhaite_arreter => false)

		dte_debut = Date.new(1900,1,1).to_datetime()
		dte_fin = Time.now()

		99.times do |n|
			nom  = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password  = "azerty"
			poids = 0
			taille = 0

			# Définit aléatoirement si l'utilisateur peut être démesuré
			demesure = [true, false].sample()

			# L'utilisateur peut être démesuré
			if demesure then

				# Fournit un poids aléatoire entre 55 et 600 kilos
				poids = 55 + Random.rand(546)

				# Fournit une taille aléatoire entre 100 cm et 300 cm
				taille = 100 + Random.rand(201)

			else # L'utilisateur a des proportions correctes
				
				# Fournit un poids aléatoire entre 65 et 105 kilos
				poids = 55 + Random.rand(51)

				# Fournit une taille aléatoire entre 120 cm et 200 cm
				taille = 120 + Random.rand(81)
			end

			# Fournit un poids idéal toujours inférieur de 1 à 10 kilos
			poids_ideal = poids - (Random.rand(10) + 1)
			
			# Fournit une date aléatoire entre 1900 et aujourd'hui
			naissance = rand_date(dte_debut, dte_fin) 

			# Fournit une valeur booléenne fumeur aléatoire
			fumeur = [true, false].sample()

			# Fournit une valeur booléenne souhaite arrêter aléatoire
			arreter = [true, false].sample()

			User.create!(	:nom => nom,
						:email => email,
						:password => password,
						:password_confirmation => password,
						:poids => poids,
						:poids_ideal => poids_ideal,
						:taille => taille,
						:dte_naissance => naissance,
						:fumeur => fumeur,
						:souhaite_arreter => arreter)
		end
	end

	# Obtient une date aléatiore entre la date de début et la date de fin (aujourd'hui par défaut)
	def rand_date(debut, fin = Time.now)
		return Time.at(rand_dans_interval(debut.to_f, fin.to_f)).to_date()
	end

	# Obtient une valeur aléatoire dans l'interval spécifié
	def rand_dans_interval(debut, fin)
		return rand * (fin - debut) + debut
	end

end
