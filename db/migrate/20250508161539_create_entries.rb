class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries do |t|
      t.integer :rank
      t.references :user, null: false, foreign_key: true
      t.references :tea, null: false, foreign_key: true
      t.timestamps
    end
  end
end
