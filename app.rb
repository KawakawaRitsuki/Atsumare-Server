require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models/gather.rb'
require 'json'
require 'uri'


get '/' do
  "ようこそ!このサイトは、POSTを掛けることによりデータベースに追加していきます。URL\"localhost:8080/add\""
end

post '/add' do
  # p request.body.read
  # params = JSON.parse request.body.read
  # p params[:hoge]
  result = JSON.parse(request.body.read)
  p result["hoge"]
  "送信完了 データ:#{result["hoge"]}"


end
