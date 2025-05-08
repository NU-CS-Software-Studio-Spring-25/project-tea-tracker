class User < ApplicationRecord
    has_many :entries, dependent: :destroy
    has_many :teas, through: :entries
    has_secure_password
  
    validates :username, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }, if: :password_digest_changed?
  end
  