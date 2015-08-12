require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
require './models/gather.rb'
require './models/user.rb'
require './models/group.rb'
require './models/groupuser.rb'
require 'json'
require 'uri'

#{"userid":"ユーザーID","password":"パスワード","nickname":"ニックネーム","latitude":"緯度","longitude":"経度","loginnow":"ログイン中"}
# u = User.new
# u.userid = result["userid"]
# u.password = result["password"]
# u.save

get '/' do
  "ようこそ!このサイトは、POSTを掛けることによりデータベースに追加していきます。URL\"localhost:8080/add\""
end

post '/get' do#取得 グループID 聞く
  result = JSON.parse(request.body.read)
  result["groupid"]

  # u = User.where(:userid => result["userid"]).first


end

post '/signup' do#ログイン部分
  result = JSON.parse(request.body.read)
  #形式: userid/password/nickname

  u = User.where(:userid => result["userid"]).first

  if u == nil
    u = User.new
    u.userid = result["userid"]
    u.password = result["password"]
    u.nickname = result["nickname"]
    u.save
    # "Signuped"
    "会員登録完了"
  else
    "同じIDのユーザーが存在しています。別のIDでお試しください。"
  end
end


post '/regist' do#受け取るデータは緯度経度とID
  result = JSON.parse(request.body.read)

  u = User.where(:userid => result["userid"]).first

  if u != nil
    u.latitude = result["latitude"]
    u.longitude = result["longitude"]
    u.save
    # "Registed"
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

post '/makegroup' do#グループ作成
  #groupname/userid

  result = JSON.parse(request.body.read)

  newgroupid = while true
    tempid = ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(5).join
    g = Group.where(:groupid => tempid).first
    if g == nil
      break tempid
    end
  end

  g  = Group.new
  g.groupid = newgroupid
  g.groupname = result["groupname"]
  g.save

  gu = Groupuser.new
  gu.groupid = newgroupid
  gu.user = result["userid"]
  gu.save

end
