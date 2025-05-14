class User < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8, message: "must be at least 8 characters long" }
  validates :password_confirmation, presence: true
end
