class AddCsvPromptSeenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :csv_prompt_seen, :boolean, default: false
  end
end
