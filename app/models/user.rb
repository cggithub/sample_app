require 'digest'
class User < ActiveRecord::Base
	# Password est un champs virtuel (non-représenté en base)
	attr_accessor(:password)

	# La liste des attributs accessibles à la modification par
	# update_attributes()
	attr_accessible(:nom, :email, :password, :password_confirmation)

	# Expression régulière de vérification des Emails
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	# Vérifie la validité du nom:
	#	- doit être existant
	#	- doit faire au maximum 50 chars
	validates(:nom,	:presence => true,
					:length   => { :maximum => 50 }
					)

	# Vérifie la validité de l'email:
	#	- doit être existant
	#	- doit respecter le format imposé par E.R. email_regex
	#	- est insensible à la casse
	validates(:email,	:presence => true,
					:format   => { :with => email_regex },
					:uniqueness => { :case_sensitive => false }
					)

	# Le paramètre ':confirmation => true' crée automatiquement
	# l'attribut virtuel 'password_confirmation'.
	# Le paramètre ':length => { :within => 6..40 }' contraint
	# la longueur du mot de passe entre 6 et 40 caractères (inclus).
	validates(:password,	:presence => true,
						:confirmation => true,
						:length => { :within => 6..40 }
			)
	# La fonction de callback appelée avant la sauvegarde / mise à jour
	# d'un utilisateur dans la base. Ici, le callback fait un appel à
	# la méthode encrypt_password charchée de crypter le mot de passe
	before_save(:encrypt_password)

	# Retourne true si le mot de passe passé en paramètre correspond
	# au mot de passe stocké en base.
	def has_password?(motDePasse)
		return self.encrypted_password == encrypt(motDePasse)
	end

	# Méthode d'authentification 
	def self.authenticate(mail, motDePasse)
		user = find_by_email(mail)
		if !user.nil?() && user.has_password?(motDePasse) then
			return user
		end
		return nil
	end

	private
		
		# La méthode appelée avant chaque sauvegarde dans la base
		# pour crypter le mot de passe
		def encrypt_password
			if new_record?() then
				self.salt = make_salt()
			end
			self.encrypted_password = encrypt(self.password)
		end

		# Cette méthode retourne la version cryptée de la chaîne de
		# caractères passée en paramètre
		def encrypt(chaine)
			return secure_hash("#{self.salt}--#{chaine}")
		end
		
		def make_salt
			return secure_hash("#{Time.now().utc()}--#{self.password}")
		end

		def secure_hash(chaine)
			return Digest::SHA2.hexdigest(chaine)
		end
end
