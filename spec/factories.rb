# encoding: utf-8

# En utilisant le symbole ':user', nous faisons en sorte que
# Factory Girl simule un modèle User.
Factory.define :user do |user|
  user.nom("John Rambo")
  user.email("john.rambo@jungle.com")
  user.password("jrambo")
  user.password_confirmation("jrambo")
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
