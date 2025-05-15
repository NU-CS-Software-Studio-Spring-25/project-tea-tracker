
class AddShipFromToTeas < ActiveRecord::Migration[8.0]
  def change
    add_column :teas, :ship_from, :string
  end
end
