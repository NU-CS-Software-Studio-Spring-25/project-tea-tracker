class CreateTeas < ActiveRecord::Migration[8.0]
  def change
    create_table :teas do |t|
      t.string :name
      t.integer :rank
      t.decimal :price
      t.string :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
