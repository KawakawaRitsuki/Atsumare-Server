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

post '/getlocate' do#メンバーの位置取得部分
  #group_id

  result = JSON.parse(request.body.read)
  u = Group.where(:group_id => result["group_id"])

  str = "{\"data\":["

  u.each do |g|
    users = g.user
    users.each do |user|
      if user.login_now == result["group_id"]
        str = str + "{\"user_id\":\"#{user.user_id}\",\"user_name\":\"#{user.user_name}\",\"latitude\":\"#{user.latitude}\",\"longitude\":\"#{user.longitude}\",\"login\":\"0\"},"
      else
        str = str + "{\"user_id\":\"#{user.user_id}\",\"user_name\":\"#{user.user_name}\",\"latitude\":\"#{user.latitude}\",\"longitude\":\"#{user.longitude}\",\"login\":\"1\"},"
      end
    end
  end

  str = str[0,str.length-1] + "]}"
  "#{str}"

end

post '/getusing' do#利用中かどうか弾く
  #group_id

  result = JSON.parse(request.body.read)
  g = Group.where(:group_id => result["group_id"]).first

  "#{g.use}"

end

post '/setusing' do#利用中かどうか弾く
  #group_id,using\
  result = JSON.parse(request.body.read)
  g = Group.where(:group_id => result["group_id"]).first
  g.use = result["using"]
  g.save
  "0"

end

post '/getgroup' do#グループ一覧取得部分
  #user_id
  result = JSON.parse(request.body.read)

  user = User.where(:user_id => result["user_id"])

  str = "{\"data\":["

  user.each do |u|
    groups = u.group
    groups.each do |g|
      str = str + "{\"group_id\":\"#{g.group_id}\",\"group_name\":\"#{g.group_name}\"},"
    end
  end

  str = str[0,str.length-1] + "]}"
  if str == "{\"data\":]}"
    "notfound"
  else
    "#{str}"
  end
end

post '/signup' do#会員登録部分
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

post '/login' do#ログイン部分
  #userid/password
  result = JSON.parse(request.body.read)
  gather = User.where(:user_id => result["user_id"]).first

  begin
    if gather.password == result["password"]
      "0"
      #この時に、Loginnowの部分を書く
    else
      "1"
    end
  rescue => e
    "1"
  end

end

post '/grouplogin' do#グループとしてのログイン部分
  #user_id/group_id
  result = JSON.parse(request.body.read)
  user = User.where(:user_id => result["user_id"]).first
  user.login_now = result["group_id"]
  user.save
  "0"

end

post '/grouplogout' do#グループとしてのログアウト部分
  #user_id
  result = JSON.parse(request.body.read)

    user = User.where(:user_id => result["user_id"]).first
  if user != nil
    user.login_now = ""
    user.save
  end

  u = Group.where(:group_id => result["group_id"])

  str = ""

  u.each do |g|
    users = g.user
    users.each do |userr|
      str = str + "#{userr.login_now}"
    end
  end

  str = str[0,str.length-1]
  "#{str}1"

end

post '/regist' do#位置登録部分
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

post '/makegroup' do#グループ作成
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

post '/ingroup' do#グループ加入
  #groupid/userid
  #一応ユーザーが存在するかどうかと、
  #重複していないかを確認
  #エラー処理適当すぎワロタｗ
  result = JSON.parse(request.body.read)

  gu = GroupsUser.new

  group = Group.where(:group_id => result["group_id"]).first
  if group == nil
    "1"
  else
    gu.group_id = group.id
    gu.user_id = User.where(:user_id => result["user_id"]).first.id
    gu.save
    "0"
  end

end

post '/outgroup' do#グループ退出
  #group_id/userid
  result = JSON.parse(request.body.read)
  user = User.where(:user_id => result["user_id"]).first
  group = Group.where(:group_id => result["group_id"]).first

  if user != nil && group != nil
    groupuser = GroupsUser.where(:user_id => user.id,:group_id => group.id).first
    groupuser.destroy

    groupuser = GroupsUser.where(:group_id => group.id)
    if groupuser.count == 0
      g = Group.where(:id => group.id).first
      g.destroy
    end
    "0"
  else
    "1"
  end

end

post '/loginstate' do#メンバーのログイン状態取得
  #group_id

  result = JSON.parse(request.body.read)
  u = Group.where(:group_id => result["group_id"])

  str = "{\"data\":["

  u.each do |g|
    users = g.user
    users.each do |user|
      str = str + "{\"user_id\":\"#{user.user_id}\",\"user_name\":\"#{user.user_name}\",\"login_now\":\"#{user.login_now}\"},"
    end
  end

  gr = Group.where(:group_id => result["group_id"]).first


  str = str[0,str.length-1] + "],\"using\":#{gr.use}}"
  "#{str}"

end
