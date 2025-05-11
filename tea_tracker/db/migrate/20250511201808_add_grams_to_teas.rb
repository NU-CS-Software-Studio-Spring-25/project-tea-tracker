class AddGramsToTeas < ActiveRecord::Migration[8.0]
  def change
    add_column :teas, :grams, :integer
  end
end
