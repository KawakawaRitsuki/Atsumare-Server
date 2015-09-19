class AddColumnGroups < ActiveRecord::Migration
  def up
     add_column :groups, :use, :integer, :default => 1
  end

  def down
     remove_column :groups, :use
  end
end
