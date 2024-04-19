class AddCreatedByToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :created_by, :integer
    add_foreign_key :projects, :users, column: :created_by
  end
end
