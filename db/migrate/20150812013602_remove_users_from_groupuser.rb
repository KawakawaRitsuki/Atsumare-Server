class RemoveUsersFromGroupuser < ActiveRecord::Migration
  def up
    remove_column :groupuser, :user1
    remove_column :groupuser, :user2
    remove_column :groupuser, :user3
    remove_column :groupuser, :user4
    remove_column :groupuser, :user5
  end

  def down
    add_column :groupuser, :user1, :string
    add_column :groupuser, :user2, :string
    add_column :groupuser, :user3, :string
    add_column :groupuser, :user4, :string
    add_column :groupuser, :user5, :string
  end
end
