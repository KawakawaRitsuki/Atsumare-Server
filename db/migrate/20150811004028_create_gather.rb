class CreateGather < ActiveRecord::Migration
 def change
   create_table :users do |t|
     t.string :userid
     t.string :password
     t.string :username
     t.integer :latitude
     t.integer :longitude
     t.string :loginnow
   end
   create_table :groups do |t|
     t.string :groupid
     t.string :groupname
   end
   create_table :groupuser do |t|
     t.string :groupid
     t.string :user1
     t.string :user2
     t.string :user3
     t.string :user4
     t.string :user5
   end
 end
end
