class ChangeDatatypeLongitudeOfUsers < ActiveRecord::Migration
  def change
    change_column :users, :latitude, :string
    change_column :users, :longitude, :string
  end
end
