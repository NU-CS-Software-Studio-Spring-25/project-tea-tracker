class Entry < ApplicationRecord
    belongs_to :user
    belongs_to :tea
    validates :rank, presence: true
    accepts_nested_attributes_for :tea
end
  