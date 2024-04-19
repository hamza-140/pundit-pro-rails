class AddDetailsToBugs < ActiveRecord::Migration[7.1]
  def change
    add_column :bugs, :deadline, :datetime
    add_column :bugs, :screenshot, :string
    add_column :bugs, :bug_type, :string, null: false, default: "feature"
    add_column :bugs, :status, :string, null: false, default: "new"
    add_index :bugs, :title, unique: true
  end
end
