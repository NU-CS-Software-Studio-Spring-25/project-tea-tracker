class AddDetailsToTeas < ActiveRecord::Migration[8.0]
  def change
    add_column :teas, :vendor, :string
    add_column :teas, :known_for, :string
    add_column :teas, :ship_from, :string
    add_column :teas, :popularity, :integer
    add_column :teas, :shopping_platform, :string
    add_column :teas, :product_url, :string
  end
end
