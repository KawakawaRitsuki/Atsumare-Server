class RenameGroupuserToGroupusers < ActiveRecord::Migration
  def change
    rename_table :groupuser, :groupusers
  end
end
