class AddNullConstraintsToUserDateOfBirth < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:users, :date_of_birth, false)
  end
end
