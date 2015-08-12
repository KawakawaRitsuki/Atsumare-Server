require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
require './models/gather.rb'
require './models/user.rb'
require 'json'
require 'uri'

get '/' do
  "ようこそ!このサイトは、POSTを掛けることによりデータベースに追加していきます。URL\"localhost:8080/add\""
end



post '/signup' do#受け取るデータは緯度経度とID
  result = JSON.parse(request.body.read)
  #{"userid":"ユーザーID","password":"パスワード","nickname":"ニックネーム","latitude":"緯度","longitude":"経度","loginnow":"ログイン中"}
  #形式: userid/password/nickname

  u = User.where(:userid => result["userid"]).first

  if u.

    p u

    u.userid = result["userid"]
    u.password = result["password"]
    u.nickname = result["nickname"]

    u.save
  end

end


post '/regist' do#受け取るデータは緯度経度とID
  result = JSON.parse(request.body.read)
  #{"userid":"ユーザーID","password":"パスワード","nickname":"ニックネーム","latitude":"緯度","longitude":"経度","loginnow":"ログイン中"}
  #形式: userid/latitude/longitude
  # u = User.new
  # u.userid = result["userid"]
  # u.password = result["password"]
  # u.save

  u = User.where(:userid => result["userid"]).first

  if u != nil
    u.latitude = result["latitude"]
    u.longitude = result["longitude"]
    u.save
    "Registed"
    "位置情報更新完了"
  else
    "そのようなUserIDは存在しません。（本来ならこのレスポンスは返りません）"
  end

end

post '/login' do#受け取るデータはID/PW
  result = JSON.parse(request.body.read)
  gather = User.find_by[userid:result["id"]]

  if gather == nil
    "IDが存在しません"
  elsif gather.password == result["password"]
    "ログイン完了"
    #この時に、Loginnowの部分を書く
  else
    "PWが違います"
  end

end

post '/signup' do#受け取るデータはID/PW/NickName
  # ログインなうはnでもいれとけ
  result = JSON.parse(request.body.read)
  gather = User.find_by[userid:result["id"]]

  if gather == nil
    "IDが存在しません"
  elsif gather.password == result["password"]
    "ログイン完了"
    #この時に、Loginnowの部分を書く
  else
    "PWが違います"
  end

  "送信完了 データ:#{result["hoge"]}"

end
