class User < ApplicationRecord
    has_secure_password
  
    has_many :teas
  
    validates :username, presence: true, uniqueness: true,
                         format: { with: /\A[a-zA-Z0-9_]+\z/,
                                   message: "can only contain letters, numbers, and underscores" }
  
    validates :password, length: { minimum: 8 },
                         format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+\z/,
                                   message: "must include upper, lower, number, and special character" }, if: :password
  end  