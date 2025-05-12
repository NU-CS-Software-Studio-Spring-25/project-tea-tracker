class Entry < ApplicationRecord
    belongs_to :user
    belongs_to :tea
    validates :position, presence: true
    accepts_nested_attributes_for :tea

    before_validation :set_default_position, on: :create

    def rank
        # Calculate rank based on position order, scoped to user
        user.entries.where('position < ?', position).count + 1
    end

    private

    def set_default_position
        return if position.present?
        # Set position to 1000 * (max position + 1) for floating island method, scoped to user
        max_position = user.entries.maximum(:position) || 0
        self.position = (max_position + 1000)
    end
end
  