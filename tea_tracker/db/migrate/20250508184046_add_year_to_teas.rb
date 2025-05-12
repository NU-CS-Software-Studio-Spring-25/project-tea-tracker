class AddYearToTeas < ActiveRecord::Migration[8.0]
  def change
    add_column :teas, :year, :integer
  end
end 