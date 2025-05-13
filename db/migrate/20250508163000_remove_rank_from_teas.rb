class RemoveRankFromTeas < ActiveRecord::Migration[8.0]
  def change
    remove_column :teas, :rank, :integer
  end
end
