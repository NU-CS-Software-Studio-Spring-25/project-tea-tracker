class NormalizeTeaCategories < ActiveRecord::Migration[8.0]
  def up
    # Ensure the column is a string type
    change_column :teas, :category, :string

    # Normalize existing categories to lowercase
    execute <<-SQL
      UPDATE teas
      SET category = LOWER(category)
      WHERE category IS NOT NULL
    SQL
  end

  def down
    # No need to revert the category normalization
  end
end
