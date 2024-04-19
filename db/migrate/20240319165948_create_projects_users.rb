class CreateProjectsUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :projects_users, id: false do |t|
      t.integer :project_id, null: false
      t.integer :user_id, null: false
    end
  end
end
