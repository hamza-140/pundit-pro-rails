class RemoveNotNullConstraintFromProjectCreatedByInProjects < ActiveRecord::Migration[7.1]
  def change
    change_column :projects, :created_by, :integer, null: true
  end
end
