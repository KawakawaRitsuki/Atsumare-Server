require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './models/user.rb'
require './models/group.rb'
require './models/groups_users.rb'
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
