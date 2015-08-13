class User < ActiveRecord::Base
  has_many :groups_user
  has_many :group, through: :groups_user
end
