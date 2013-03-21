module ApplicationHelper

	# Fonction titre : retourne un titre en fonction de la page visitée
	def titre()

		# La base commune à tous les titres
		base_titre = "Simple App du Tutoriel Ruby on Rails"
		
		# Le titre pour la page est-il null ?
		if @titre.nil?

			# titre null, retourne la base. 
			return base_titre

		else
			
			# titre non-null, retourne base | titre
			return "#{base_titre} | #{@titre}"

		end	# Fin titre est-il null

	end	# Fin Fonction titre

end
