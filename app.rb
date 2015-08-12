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

get '/' do#将来的に削除したほうがいいかも。実際不要なメソッドだし
  "ようこそ!このサイトは、POSTを掛けることによりデータベースに追加していきます。"
end

post '/get' do#取得 グループID 聞く
  result = JSON.parse(request.body.read)
  result["groupid"]

  # u = User.where(:userid => result["userid"]).first
end

post '/signup' do#会員登録部分/実装完了
  #userid/password/nickname
  result = JSON.parse(request.body.read)
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

post '/regist' do#緯度経度登録部分/実装完了
  #userid/latitude/longitude
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

post '/login' do#ログイン部分/仮実装完了
  #userid/password
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

post '/makegroup' do#グループ作成/実装完了
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

post '/ingroup' do#グループ作成/実装完了
  #groupid/userid
  result = JSON.parse(request.body.read)

  g = Group.where(:groupid => result["groupid"]).first

  if g != nil
    gu = Groupuser.new
    gu.groupid = result["groupid"]
    gu.user = result["userid"]
    gu.save

    "グループ名:#{g.groupname}に入りました。"
  else
    "グループが存在しません。グループIDを確認して下さい。"
  end

end
