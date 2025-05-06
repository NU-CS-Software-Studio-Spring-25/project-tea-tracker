class Tea < ApplicationRecord
  belongs_to :user
  validates :name, :rank, :price, :category, presence: true
end
