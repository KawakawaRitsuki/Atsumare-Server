require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
require './models/user.rb'
require './models/group.rb'
require './models/groups_user.rb'
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

post '/get' do#取得部分/未実装
  #groupid
  result = JSON.parse(request.body.read)



  Group.find(8).groupuser.groupname

  groupuser = Groupuser.where(:groupid => result["groupid"]).first
  # for group.pluck(:user).
  # puts group

  # u = User.find_by(user: group.)

  group = groupuser.groups

  puts group.latitude

  group.pluck(:user).size.times{ |e|
    puts group.pluck(:user)[e]
  }

end

post '/signup' do#会員登録部分/実装完了
  #user_id/password/user_name
  result = JSON.parse(request.body.read)
  u = User.where(:user_id => result["user_id"]).first

  if u == nil
    u = User.new
    u.user_id = result["user_id"]
    u.password = result["password"]
    u.user_name = result["user_name"]
    u.latitude = 0
    u.longitude = 0
    u.login_now = ""
    u.save
    # "Signuped"
    "会員登録完了"
  else
    "同じIDのユーザーが存在しています。別のIDでお試しください。"
  end
end

  #userid/password
  result = JSON.parse(request.body.read)
  gather = User.find_by[user_id:result["id"]]

  if gather == nil
    "IDが存在しません"
  elsif gather.password == result["password"]
    "ログイン完了"
    #この時に、Loginnowの部分を書く
  else
    "PWが違います"
  end

end

post '/regist' do#緯度経度登録部分/実装完了
  #userid/latitude/longitude
  result = JSON.parse(request.body.read)

  u = User.where(:user_id => result["user_id"]).first

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

post '/makegroup' do#グループ作成/実装完了
  #group_name/user_id
  result = JSON.parse(request.body.read)

  newgroupid = while true
    tempid = ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(5).join
    g = Group.where(:group_id => tempid).first
    if g == nil
      break tempid
    end
  end

  g  = Group.new
  g.group_id = newgroupid
  g.group_name = result["group_name"]
  g.save

  gu = GroupsUser.new
  gu.group_id = newgroupid
  gu.user_id = result["user_id"]
  gu.save

end

post '/ingroup' do#グループに入る/実装完了
  #groupid/userid
  #一応ユーザーが存在するかどうかと、
  #重複していないかを確認
  result = JSON.parse(request.body.read)

  g = Group.where(:group_id => result["group_id"]).first

  if g != nil
    gu = Groupuser.new
    gu.group_id = result["group_id"]
    gu.user_id = result["user_id"]
    gu.save

    "グループ名:#{g.groupname}に入りました。"
  else
    "グループが存在しません。グループIDを確認して下さい。"
  end
end

# post '/outgroup' do#グループから出る/実装完了（未確認）
#   #groupid/userid
#   result = JSON.parse(request.body.read)
#   g = Group.where(:groupid => result["groupid"]).first
#
#   if g != nil
#     gu = Groupuser.where(:groupid => result["groupid"]).first
#     gu.destroy
#     "グループ名:#{g.groupname}から退出しました。"
#   else
#     "このグループには入っていません。グループIDを確認して下さい。"
#   end
# end
