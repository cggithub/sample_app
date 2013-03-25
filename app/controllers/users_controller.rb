# encoding: utf-8

class UsersController < ApplicationController

	# Définit une méthode authenticate qui sera appellée avant
	# toutes les actions liées à edit et update (before-filter)
	before_filter(:authenticate, :only => [:edit, :update, :index])
	before_filter(:correct_user, :only => [:edit, :update])
	before_filter(:goto_accueil, :only => [:new, :create])

	# Affiche tous les utilisateurs
	def index
		@titre = "Tous les utilisateurs"
		@users = User.paginate(:page => params[:page])
	end

	# Affiche la page d'inscription
	def new
		@user = User.new()
		@titre = "Inscription"
	end

	# Affiche le profil d'un utilisateur
	def show
		@user = User.find(params[:id])
		@titre = @user.nom
	end

	# Crée un utilisateur dans la base de données
	def create
		@user = User.new(params[:user])
		if @user.save() then
			# Succès à l'inscription
			sign_in(@user) # Connexion
			flash[:success] = "Bienvenue dans l'application exemple !"
			redirect_to(@user)
		else
			# Echec à l'inscription
			@titre = "Inscription"
			@user.password.clear()
			@user.password_confirmation.clear()
			# ATTENTION, BUG TOUT POURRI SPOTTED
			# Ne pas mettre 'new' mais bien :new sinon
			# la page n'est pas correctement rendue
			# Raison: aucune (rails illogique)
			render(:new)
		end
	end

	# Edite les informations d'un utilisateur
	def edit
		@titre = "Édition profil"
	end

	# Met à jour le profil utilisateur dans la base de données.
	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user]) then
			flash[:success] = "Profil actualisé."
			redirect_to(@user)
		else
			@titre = "Édition profil"
			render(:edit)
		end
	end

	private

		# Force l'utilisateur à s'authentifier
		def authenticate
			deny_access() unless signed_in?()
		end

		# Redirige l'utilisateur tant qu'il ne s'agit de l'utilisateur courant
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		# Redirige vers l'accueil tout utilisateur tentant une action create ou new alors qu'il est authentifié
		def goto_accueil
			if signed_in?() then
				redirect_to(root_path)
			end
		end

end
