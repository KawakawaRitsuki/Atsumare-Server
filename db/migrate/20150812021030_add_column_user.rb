class AddColumnUser < ActiveRecord::Migration
  def change
    add_column :groupuser, :user, :string
  end
end
