class AddUserIdToTeas < ActiveRecord::Migration[7.1]
  def change
    # First add the column without constraints
    add_reference :teas, :user, foreign_key: true, null: true

    # Then update any existing records (if needed)
    reversible do |dir|
      dir.up do
        # Get the first user's ID or create a default user
        user_id = User.first&.id
        if user_id
          execute <<-SQL
            UPDATE teas SET user_id = #{user_id} WHERE user_id IS NULL;
          SQL
        end
      end
    end

    # Finally, add the not-null constraint
    change_column_null :teas, :user_id, false
  end
end 