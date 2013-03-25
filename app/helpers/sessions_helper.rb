# encoding: utf-8

module SessionsHelper

	# Authentifie un utilisateur et stocke ses paramètres dans l'objet current_user
	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		self.current_user = user
	end

	# Définit un utilisateur comme étant l'utilisateur courant (current_user)
	def current_user=(user)
		@current_user = user
	end

	# Obtient l'utilisateur courant
	def current_user
		@current_user ||= user_from_remember_token
	end

	# Obtient true si l'utilisateur est connecté, false sinon.
	def signed_in?
		return !current_user.nil?()
	end

	# Déconnecte l'utilisateur courant
	def sign_out
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	# Interdit l'accès à une page et redirige vers la page de connexion
	def deny_access
		store_location
		flash[:notice] = "Merci de vous identifier pour accéder à cette page."
		redirect_to(signin_path)
	end

	# Obtient true si l'utilisateur en paramètre est l'utilisateur courant, sinon false.
	def  current_user?(user)
		return user == current_user
	end
	
	# Redirige vers la page de retour stockée dans la session si une url est présente.
	# Le cas échéant, redirige vers la page par défaut spécifiée en paramètre.
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end

	private

		# Obtient les paramètres de l'utilisateur courant à partir de la chaine de connexion du cookie
		def user_from_remember_token
			return User.authenticate_with_salt(*remember_token)
		end

		# Obtient la chaine de connexion du cookie de l'utilisateur courant
		def remember_token
			return cookies.signed[:remember_token] || [nil, nil]
		end

		# Stocke l'url de la page courante, comme url de retour dans la session.
		def store_location
			session[:return_to] = request.fullpath
		end

		# Efface l'éventuelle url de retour stockée dans la session précédemment.
		def clear_return_to
			session[:return_to] = nil
		end

end
