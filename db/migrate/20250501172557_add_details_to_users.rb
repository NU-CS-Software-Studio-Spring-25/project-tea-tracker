class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :avatar_url, :string
    add_column :users, :password_digest, :string
  end
end
