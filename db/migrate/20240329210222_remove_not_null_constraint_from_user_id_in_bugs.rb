class RemoveNotNullConstraintFromUserIdInBugs < ActiveRecord::Migration[7.1]
  def change
    change_column :bugs, :user_id, :integer, null: true
  end
end
