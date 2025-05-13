class AddPriceFieldsToTeas < ActiveRecord::Migration[8.0]
  def change
    add_column :teas, :price_mode, :string
    add_column :teas, :total_price, :decimal, precision: 10, scale: 2
    add_column :teas, :weight, :decimal, precision: 10, scale: 2
  end
end 