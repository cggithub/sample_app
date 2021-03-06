# encoding: utf-8

# En utilisant le symbole ':user', nous faisons en sorte que
# Factory Girl simule un modèle User.
Factory.define :user do |user|
	user.nom("John Rambo")
	user.email("john.rambo@jungle.com")
	user.password("jrambo")
	user.password_confirmation("jrambo")
	user.poids(90)
	user.poids_ideal(86)
	user.taille(180)
	user.fumeur(true)
	user.souhaite_arreter(true)
	user.dte_naissance(Date.new(1950, 1, 15))
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
