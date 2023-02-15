class User < ApplicationRecord
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

    validates :password,presence: true, length: { minimum: 6 }
end
