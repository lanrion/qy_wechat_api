开发中...

部门、成员、标签、自定义菜单、Oauth2 接口均可以在开发环境调试

**企业号对应多个管理组，请前往 `设置` => `权限管理` 任意创建一个管理组，在管理组最下角即可获取 CorpID Secret**

**有问题请及时提issue**

```ruby
gem "qy_wechat_api", git: "https://github.com/lanrion/qy_wechat_api.git"
```

**暂未对access_token做缓存处理，为了确保在开发过程不会出现token过期问题，请不要使用全局变量存储group_client。**

# 配置
此项配置，仅用于你使用redis存储token，否则不需要!

在：your_project_name/config/initializers/qy_wechat_api.rb 添加：

```ruby
# don't forget change namespace
namespace = "your_project_name:qy_wechat_api"
redis = Redis.new(:host => "127.0.0.1", :port => "6379", :db => 15)

# cleanup keys in the current namespace when restart server everytime.
exist_keys = redis.keys("#{namespace}:*")
exist_keys.each{|key|redis.del(key)}

# Give a special namespace as prefix for Redis key, when your have more than one project used qy_wechat_api, this config will make them work fine.
redis = Redis::Namespace.new("#{namespace}", :redis => redis)

QyWechatApi.configure do |config|
  config.redis = redis
end
```


# API基本用法

请务必结合：http://qydev.weixin.qq.com/wiki/index.php 理解以下API参数使用。

## 初始化

```ruby
group_client = QyWechatApi::Client.new(corpid, corpsecret)
```

## 部门

```ruby
group_client.department.create(name, parent_id, order=nil)
group_client.department.update(id, name, parent_id, order=nil)
group_client.department.delete(id)
group_client.department.list
```

## 成员

```ruby
group_client.user.create(user_id, name, options={})
group_client.user.update(user_id, options={})
group_client.user.delete(user_id)
group_client.user.get(user_id)
group_client.user.simple_list(department_id, fetch_child=nil, status=nil)
```

## 标签

```ruby
group_client.tag.create(name)
group_client.tag.update(id, name)
group_client.tag.delete(id)
group_client.tag.get(id)
group_client.tag.add_tag_users(id, user_ids)
group_client.tag.delete_tag_users(id, user_ids)
group_client.tag.list
```

## 自定义菜单

menu_json的生成方法请参考:
https://github.com/lanrion/weixin_rails_middleware/wiki/DIY-menu

```ruby
group_client.menu.create(menu_json, app_id)
group_client.menu.delete(app_id)
group_client.menu.get(app_id)
```

## Oauth2用法

先要配置你应用的 可信域名 `2458023e.ngrok.com`
state 为开发者自定义参数，可选

```ruby
# 生成授权url
group_client.oauth.authorize_url("http://2458023e.ngrok.com", "state")

# 获取code后，获取用户信息
# app_id: 跳转链接时所在的企业应用ID
group_client.oauth.get_user_info("code", "app_id")
```

## 发送消息

```ruby
  # params: (users, parties, tags, agent_id, content, safe=0)
  # users, parties, tags 如果是多个用户，传数组，如果是全部，则直接传 "@all"
  group_client.message.send_text("@all", "@all", "@all", app_id, text_message)
```
**其他发送消息方法请查看 api/message.rb**

## 上传多媒体文件
```ruby
# params: media, media_type
group_client.media.upload(image_jpg_file, "image")

# 获取下载链接
# 返回一个URL，请开发者自行使用此url下载
group_client.media.get_media_by_id(media_id)
```


