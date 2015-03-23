# QyWechatApi

This project rocks and uses MIT-LICENSE.

https://rubygems.org/gems/qy_wechat_api

[![Gem Version](https://badge.fury.io/rb/qy_wechat_api.svg)](http://badge.fury.io/rb/qy_wechat_api)

**企业号对应多个管理组，请前往 `设置` => `权限管理` 任意创建一个管理组，在管理组最下角即可获取 CorpID Secret**

**有问题请及时提issue**

```ruby
gem "qy_wechat_api", git: "https://github.com/lanrion/qy_wechat_api.git"
```

# Token 存储方案

## 对象存储
如果你是单个企业号，建议使用这个方案，无需任何配置即可使用。

## Redis 存储
```ruby
redis = Redis.new(host: "127.0.0.1", port: "6379")

namespace = "qy_wechat_api:redis_storage"

# cleanup keys in the current namespace when restart server everytime.
exist_keys = redis.keys("#{namespace}:*")
exist_keys.each{|key|redis.del(key)}

redis_with_ns = Redis::Namespace.new("#{namespace}", redis: redis)

QyWechatApi.configure do |config|
  config.redis = redis_with_ns
end
```

## 自定义存储方案
TODO...

# API基本用法

请务必结合：http://qydev.weixin.qq.com/wiki/index.php 理解以下API参数使用。

## 初始化

```ruby
group_client = QyWechatApi::Client.new(corpid, corpsecret)
# 为了确保用户输入的corpid, corpsecret是准确的，请务必执行：
group_client.is_valid?
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
<!-- 创建成员 -->
group_client.user.create(user_id, name, options={})
<!-- 更新成员 -->
group_client.user.update(user_id, options={})
<!-- 删除成员 -->
group_client.user.delete(user_id)
<!-- 批量删除成员 -->
group_client.user.batch_delete(user_ids)
<!-- 获取成员 -->
group_client.user.get(user_id)
<!-- 获取部门成员 -->
group_client.user.simple_list(department_id, fetch_child=nil, status=nil)
<!-- 获取部门成员(详情) -->
group_client.user.full_list(department_id, fetch_child=nil, status=nil)
<!-- 邀请成员关注 -->
group_client.user.send_invitation(user_id, tips=nil)
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

## 第三方应用

这里特别注意：保留 suite_access_token的cache是直接利用了 Rails.cache，请务必在Rails框架下使用此gem。

### api 使用介绍

```ruby
suite_api = QyWechatApi::Suite.service(suite_id, suite_secret, suite_ticket)

# 获取预授权码
suite_api.get_pre_auth_code(appid=[])

# 获取企业号的永久授权码
suite_api.get_permanent_code(auth_code)

# 获取企业号的授权信息
suite_api.get_auth_info(auth_corpid, code)

# 获取企业号应用
suite_api.get_agent(auth_corpid, code, agent_id)

# 设置授权方的企业应用的选项设置信息
suite_api.set_agent(auth_corpid, permanent_code, agent_info)

# 调用企业接口所需的access_token
suite_api.get_crop_token(auth_corpid, permanent_code)
```

### 应用套件的回调通知处理

Wiki: http://qydev.weixin.qq.com/wiki/index.php?title=%E7%AC%AC%E4%B8%89%E6%96%B9%E5%9B%9E%E8%B0%83%E5%8D%8F%E8%AE%AE

```ruby
class QyServicesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :receive_ticket

  # TODO: 需要创建表: suites
  def receive_ticket
    param_xml = request.body.read
    aes_key   = "NJgquXf6vnYlGpD5APBqlndAq7Nx8fToiEz5Wbaka47"
    aes_key   = Base64.decode64("#{aes_key}=")
    hash      = MultiXml.parse(param_xml)['xml']
    @body_xml = OpenStruct.new(hash)
    suite_id  = "tj86cd0f5b8f7ce20d"
    content   = QyWechat::Prpcrypt.decrypt(aes_key, @body_xml.Encrypt, suite_id)[0]
    hash      = MultiXml.parse(content)["xml"]
    Rails.logger.info hash
    render text: "success"
    # {"SuiteId"=>"tj86cd0f5b8f7ce20d",
    #  "SuiteTicket"=>"Pb5M0PEQFZSNondlK1K_atu2EoobY9piMcQCdE3URiCG3aTwX5WBTQaSsqCzaD-0",
    #  "InfoType"=>"suite_ticket",
    #  "TimeStamp"=>"1426988061"}
  end
end
```

