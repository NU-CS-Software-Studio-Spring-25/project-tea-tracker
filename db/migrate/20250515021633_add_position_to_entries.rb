class AddPositionToEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :entries, :position, :integer
  end
end
