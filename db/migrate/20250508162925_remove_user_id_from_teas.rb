class RemoveUserIdFromTeas < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :teas, :users
    remove_index :teas, :user_id
    remove_column :teas, :user_id, :bigint
  end
end
