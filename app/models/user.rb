# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#
class User < ApplicationRecord

    attr_accessor :remember_token, :activation_token
    
    # filtros ...
    before_save   :downcase_email
    before_create :create_activation_digest

    # validar campos no vacios/nulos
    # validates :name, presence: true # forma 1. #
    # validates(:name, presence: true) # forma 2.

    # validar longitud
    validates :name,  presence: true, length: { maximum: 50 }

    # validar email
    before_save { self.email = email.downcase } # antes de guardarse en bd el email es pasado a lowerCase
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
                    # uniqueness: { case_sensitive: false } # detecte entre mayusculas y minisculas
    has_secure_password

    validates :password,presence: true, length: { minimum: 6 }, allow_nil: true

    # Returns the hash digest of the given string.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
      SecureRandom.urlsafe_base64
    end

    def remember
      # user.remember_token: 1RyMfwWNAd_B7RAcwq2qbg
      # user.remember_digested: $2a$12$4VkptMuB83souIXnqHgqIediuR/Ijv6yI1mEapC.Z4OOqEFP9CF4W
      # user.remember_token debe de hacer match con user.remember_digested

      self.remember_token = User.new_token # generar token 
      update_attribute(:remember_digest, User.digest(remember_token))
      remember_digest 
    end

      # Returns a session token to prevent session hijacking.
    # We reuse the remember digest for convenience.
    def session_token
      remember_digest || remember
    end
  
     # Returns true if the given token matches the digest.
    # def authenticated?(remember_token)
    #   return false if remember_digest.nil?
    #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # end

    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest") # trae la propiedad user.attribute_digest (mirar cuaderno)
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    class << self
      # Returns the hash digest of the given string.
      def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
    
      # Returns a random token.
      def self.new_token
        SecureRandom.urlsafe_base64
      end
    end


    # Forgets a user.
    def forget
      update_attribute(:remember_digest, nil)
    end

    # Activates an account.
    def activate
      update_attribute(:activated,    true)
      update_attribute(:activated_at, Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end



    # metodos privados de la clase User
    private

    # Converts email to all lowercase.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
