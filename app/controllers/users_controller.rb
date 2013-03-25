# encoding: utf-8

class UsersController < ApplicationController
	def new
		@user = User.new()
		@titre = "Inscription"
	end

	def show
		@user = User.find(params[:id])
		@titre = @user.nom
	end

	def create
		@user = User.new(params[:user])
		if @user.save()
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
			# la page n'est pas correctement interprétée
			# Raison: aucune (rails illogique)
			render(:new)
		end
	end
end
