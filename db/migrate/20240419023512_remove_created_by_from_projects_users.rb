class RemoveCreatedByFromProjectsUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :projects_users, :created_by
  end
end
