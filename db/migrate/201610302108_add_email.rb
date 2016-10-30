class AddEmail < ActiveRecord::Migration
  def up
    add_column :users, :email, :string
    add_column :users, :status, :integer
    rename_column :users, :name, :username
  end

  def down
    rename_column :users, :username, :name
    remove_column :users, :email, :string
    remove_column :users, :status, :integer
  end
end
