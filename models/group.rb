class Group < ActiveRecord::Base
  has_many :groups_user
  has_many :user, through: :groups_user
end
