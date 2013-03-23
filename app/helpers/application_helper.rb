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

	# Fonction logo : retourne une balise html contenant le logo du site et un texte alternatif
	def logo()
		
		# Le fichier du logo situé dans public/html/
		fichier = "logo.png"
		
		# Le texte alternatif à afficher si le fichier est inaccessible
		texte = "Application Exemple"
		
		# La classe CSS de la balise logo
		classe_css = "round"

		# Retourne le logo
		return image_tag(fichier, { :alt => texte, :class => classe_css })
	end	# Fin fonction logo

end
