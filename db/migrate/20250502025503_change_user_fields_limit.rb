class ChangeUserFieldsLimit < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :avatar_url, :string, limit: 255
    change_column :users, :bio, :string, limit: 500
  end
end
