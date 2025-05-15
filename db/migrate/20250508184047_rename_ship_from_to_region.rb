
class RenameShipFromToRegion < ActiveRecord::Migration[8.0]
  def change
    rename_column :teas, :ship_from, :region
  end
end
