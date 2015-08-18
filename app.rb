require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
require './models/user.rb'
require './models/group.rb'
require './models/groups_users.rb'
require 'json'
require 'uri'

#{"userid":"ユーザーID","password":"パスワード","nickname":"ニックネーム","latitude":"緯度","longitude":"経度","loginnow":"ログイン中"}
# u = User.new
# u.userid = result["userid"]
# u.password = result["password"]
# u.save

# レスポンス合わせる
#
# 0...成功
# 1~...失敗
# その他、情報の取得等はJSON形式で返す


post '/get' do#取得部分/実装
  #group_id

  result = JSON.parse(request.body.read)
  u = Group.where(:group_id => result["group_id"])

  str = "{\"data\":["

  u.each do |g|
    users = g.user
    users.each do |user|
      str = str + "{\"user_id\":\"#{user.user_id}\",\"user_name\":\"#{user.user_name}\",\"latitude\":\"#{user.latitude}\",\"longitude\":\"#{user.longitude}\"},"
    end
  end

  str = str[0,str.length-2] + "]}"
  "#{str}"

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
    "0"
  else
    "1"
  end
end

post '/login' do#ログイン部分/仮実装完了
  #userid/password
  result = JSON.parse(request.body.read)
  gather = User.where(:user_id => result["user_id"]).first
  if gather.password == result["password"]
    "0"
    #この時に、Loginnowの部分を書く
  else
    "1"
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
    "0"
  else
    "1"
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

  u = User.where(:user_id => result["user_id"]).first
  u.group.create(:group_name => result["group_name"],:group_id => newgroupid)

  "#{newgroupid}"
end

post '/ingroup' do#グループに入る/実装完了
  #groupid/userid
  #一応ユーザーが存在するかどうかと、
  #重複していないかを確認
  result = JSON.parse(request.body.read)

  gu = GroupsUser.new
  gu.group_id = Group.where(:group_id => result["group_id"]).first.id
  gu.user_id = User.where(:user_id => result["user_id"]).first.id
  gu.save

end

post '/outgroup' do#グループから出る/実装完了
  #group_id/userid
  result = JSON.parse(request.body.read)
  #
  # groupuser = GroupsUser.where(:id => 25)
  # puts groupuser.count

  user = User.where(:user_id => result["user_id"]).first
  group = Group.where(:group_id => result["group_id"]).first

  if user != nil && group != nil
    groupuser = GroupsUser.where(:user_id => user.id,:group_id => group.id).first
    groupuser.destroy

    groupuser = GroupsUser.where(:group_id => group.id)
    if groupuser.count == 0
      g = Group.where(:id => group.id).first
      g.destroy
      "最終退出者です。グループを破棄しました。"
    else
      "グループから退出しました。"
    end


  else
    "1"
  end

  #グループのメンバーが0じゃないかを確認しないと

end
