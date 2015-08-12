require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './models/gather.rb'
require './models/group.rb'
require './models/groupuser.rb'
require './models/user.rb'
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
