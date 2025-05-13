class UpdateUserFieldLengths < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :username, :string, limit: 50
    change_column :users, :avatar_url, :string, limit: 255
  end
end
