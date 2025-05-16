class PopulateRequiredTeaFields < ActiveRecord::Migration[8.0]
  def up
    # Set defaults for existing records with NULL values
    current_year = Date.current.year

    # Get count of records that need updating
    count = execute("SELECT COUNT(*) FROM teas WHERE vendor IS NULL OR known_for IS NULL OR year IS NULL OR region IS NULL OR ship_from IS NULL OR popularity IS NULL OR shopping_platform IS NULL OR product_url IS NULL").first["count"].to_i

    puts "Updating #{count} tea records with default values for required fields..."

    # Update records with NULL values
    execute <<-SQL
      UPDATE teas
      SET#{' '}
        vendor = COALESCE(vendor, 'Unknown Vendor'),
        known_for = COALESCE(known_for, 'Traditional'),
        year = COALESCE(year, #{current_year}),
        region = COALESCE(region, 'Unknown Region'),
        ship_from = COALESCE(ship_from, 'Unknown Location'),
        popularity = COALESCE(popularity, 50),
        shopping_platform = COALESCE(shopping_platform, 'Unknown Platform'),
        product_url = COALESCE(product_url, 'https://example.com/product')
      WHERE#{' '}
        vendor IS NULL OR#{' '}
        known_for IS NULL OR#{' '}
        year IS NULL OR#{' '}
        region IS NULL OR#{' '}
        ship_from IS NULL OR#{' '}
        popularity IS NULL OR#{' '}
        shopping_platform IS NULL OR#{' '}
        product_url IS NULL
    SQL

    # Add NOT NULL constraints after populating data
    change_column_null :teas, :vendor, false
    change_column_null :teas, :known_for, false
    change_column_null :teas, :year, false
    change_column_null :teas, :region, false
    change_column_null :teas, :ship_from, false
    change_column_null :teas, :popularity, false
    change_column_null :teas, :shopping_platform, false
    change_column_null :teas, :product_url, false
  end

  def down
    # Remove NOT NULL constraints
    change_column_null :teas, :vendor, true
    change_column_null :teas, :known_for, true
    change_column_null :teas, :year, true
    change_column_null :teas, :region, true
    change_column_null :teas, :ship_from, true
    change_column_null :teas, :popularity, true
    change_column_null :teas, :shopping_platform, true
    change_column_null :teas, :product_url, true

    # We don't reset the values as that would be destructive
  end
end
