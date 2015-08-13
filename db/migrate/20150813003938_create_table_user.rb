class CreateTableUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
     t.string :user_id
     t.string :password
     t.string :user_name
     t.integer :latitude
     t.integer :longitude
     t.string :login_now
   end
   create_table :groups do |t|
     t.string :group_id
     t.string :group_name
   end
   create_table :groups_users do |t|
     t.string :group_id
     t.string :user_id
   end
  end
end
