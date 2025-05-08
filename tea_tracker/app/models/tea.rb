class Tea < ApplicationRecord
  has_many :entries
  has_many :users, through: :entries
  validates :name, :price, :category, presence: true
end
