class User

	# Getters/setters pour les variables d'instance @nom et @email.
	attr_accessor :nom, :email

	# Constructeur
	# attributes = [Optionnel] par défaut une table de hachage vide.
	def initialize(attributes = {})
		@nom = attributes[:nom]
		@email = attributes[:email]
	end
	
	# Retourne l'email correctement formaté.
	def formatted_email
		return "#{@nom} <#{@email}>"
	end

end
