# QyWechatApi

This project rocks and uses MIT-LICENSE.

https://rubygems.org/gems/qy_wechat_api

[![Gem Version](https://badge.fury.io/rb/qy_wechat_api.svg)](http://badge.fury.io/rb/qy_wechat_api)

**企业号对应多个管理组，请前往 `设置` => `权限管理` 任意创建一个管理组，在管理组最下角即可获取 CorpID Secret**

**有问题请及时提issue**

```ruby
gem "qy_wechat_api", git: "https://github.com/lanrion/qy_wechat_api.git"
```

# 配置

## jsticket、suite_token存储方案
如果你是在Rails框架下，默认情况下直接使用Rails.cache，如果你想独立cache，请配置如下：
```ruby
QyWechatApi.configure do |config|
  config.cache_store = YourCustomCacheStore
end
```
cache_store按照Rails.cache的接口实现，强烈建议使用ActiveSupport::Cache

## 日志配置
如果你是在Rails框架下，默认情况下直接使用Rails.logger，如果你想独立cache，请配置如下：
```ruby
QyWechatApi.configure do |config|
  config.logger = YourCustomLogger
end
```
logger按照Rails.logger的接口实现，强烈建议使用ActiveSupport::Logger

## Token 存储方案（TODO: 待重构直接使用cache_store）

### 对象存储
如果你是单个企业号，建议使用这个方案，无需任何配置即可使用。

### Redis 存储
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

# API基本用法

请务必结合：http://qydev.weixin.qq.com/wiki/index.php 理解以下API参数使用。

## 初始化

```ruby
group_client = QyWechatApi::Client.new(corpid, corpsecret)

# 为了确保用户输入的corpid, corpsecret是准确的，请务必执行：
group_client.is_valid?
```

如果需要使用通过第三方应用 **获取企业号access_token** API 获取的 access_token
做如下处理：

```ruby
options = {access_token: "access_token"}
# redis_key 也可定制
group_client = QyWechatApi::Client.new(corpid, corpsecret, options)
```

## 部门

```ruby
group_client.department.create(name, parent_id, order=nil, id=nil)
group_client.department.update(id, name, parent_id, order=nil)
group_client.department.delete(id)
group_client.department.list
```

## 成员

```ruby
# 创建成员
group_client.user.create(user_id, name, options={})

# 更新成员
group_client.user.update(user_id, options={})

# 删除成员
group_client.user.delete(user_id)

# 批量删除成员
group_client.user.batch_delete(user_ids)

# 获取成员
group_client.user.get(user_id)

# 获取部门成员
group_client.user.simple_list(department_id, fetch_child=nil, status=nil)

# 获取部门成员(详情)
group_client.user.full_list(department_id, fetch_child=nil, status=nil)

# 邀请成员关注
group_client.user.send_invitation(user_id, tips=nil)

# userid转换成openid接口(企业支付需要使用到)
group_client.covert_to_open_id(user_id, agent_id="")

# openid转换成userid接口
group_client.covert_to_user_id(open_id)
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

# 上传永久图文素材
# articles 为图文列表：
{
 "title": "Title01",
 "thumb_media_id": "2-G6nrLmr5EC3MMb_-zK1dDdzmd0p7cNliYu9V5w7o8K0",
 "author": "zs",
 "content_source_url": "",
 "content": "Content001",
 "digest": "airticle01",
 "show_cover_pic": "0"
}
group_client.material.add_mpnews(agent_id, articles)

# 更新图文素材
group_client.material.update_mpnews(agent_id, media_id, articles=[])

# 上传其他类型永久素材
# type: "image", "voice", "video", "file"
# file: File
group_client.material.add_material(agent_id, type, file)

# 删除永久素材
group_client.material.del(agent_id, media_id)

# 获取素材总数
group_client.material.get_count(agent_id)

# 获取素材列表
group_client.material.list(agent_id, type, offset, count=20)
```

## 第三方应用

这里特别注意：保留 suite_access_token的cache是直接利用了前文配置的cache_store缓存。

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
suite_api.get_corp_token(auth_corpid, permanent_code)

# 生成授权URL
suite_api.auth_url(code, uri, state="suite")

```

## 企业号登录授权

```ruby
# 获取登录授权URL
# state default 'qy_wechat', option
# 此处授权回调时会传递auth_code、expires_in，auth_code用于get_login_info(获取企业号管理员登录信息)接口使用
group_client.auth_login.auth_login_url("redirect_uri", "state")

# 获取应用提供商凭证
# provider_secret:提供商的secret，在提供商管理页面可见
# 此处会返回：provider_access_token（已通过QyWechatApi.cache缓存7100s）
group_client.auth_login.get_provider_token(provider_secret)

# 通过传递provider_access_token,获取企业号管理员登录信息
group_client.auth_login.get_login_info(auth_code, provider_access_token)

# 通过传递provider_secret,获取企业号管理员登录信息
group_client.auth_login.get_login_info_by_secret(auth_code, provider_secret)

# 获取登录企业号官网的url
group_client.auth_login.get_login_url(ticket, provider_token, target, agentid=nil)
```

## 异步任务接口

```ruby
# 邀请成员关注
group_client.async_task.invite_user(callback, invite_info={})
# 增量更新成员
group_client.async_task.sync_user(callback, media_id)
# 全量覆盖成员
group_client.async_task.replace_user(callback, media_id)
# 全量覆盖部门
group_client.async_task.replace_party(callback, media_id)
# 获取异步任务结果
group_client.async_task.get_result(job_id)
```

## 获取js api签名包
```ruby
group_client.sign_package(request.url)
```

## 管理企业号应用

```ruby
# 获取应用概况列表
group_client.agent.list

# 设置企业号应用
# agentid  企业应用的id
# report_location_flag 企业应用是否打开地理位置上报 0：不上报；1：进入会话上报；2：持续上报
# logo_mediaid 企业应用头像的mediaid，通过多媒体接口上传图片获得mediaid，上传后会自动裁剪成方形和圆形两个头像
# name 企业应用名称
# description  企业应用详情
# redirect_domain  企业应用可信域名
# isreportuser 是否接收用户变更通知。0：不接收；1：接收
# isreportenter  是否上报用户进入应用事件。0：不接收；1：接收
group_client.agent.set()

## 获取企业号应用
group_client.agent.get(agent_id)
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

### 企业号消息接口

Wiki: http://qydev.weixin.qq.com/wiki/index.php?title=%E4%BC%81%E4%B8%9A%E5%8F%B7%E6%B6%88%E6%81%AF%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E

```ruby
group_client.chat.send_single_text(sender, user_id, msg)
group_client.chat.send_single_image(sender, user_id, media_id)
group_client.chat.send_single_file(sender, user_id, media_id)
group_client.chat.send_group_text(sender, chat_id, msg)
group_client.chat.send_group_image(sender, chat_id, media_id)
group_client.chat.send_group_file(sender, chat_id, media_id)
```

### 企业客服服务

Wiki: http://qydev.weixin.qq.com/wiki/index.php?title=企业客服接口说明

```ruby
# msg_struct请根据文档结构拼接传入
group_client.kf.send(msg_struct)
```

### 企业号摇一摇周边

Wiki: http://qydev.weixin.qq.com/wiki/index.php?title=获取设备及用户信息

```ruby
# 获取设备及用户信息
# 摇周边业务的ticket，可在摇到的URL中得到，ticket生效时间为30分钟，每一次摇都会重新生成新的ticket
group_client.get_shake_info(ticket)
```

## 捐赠支持

  如果你觉得我的gem对你有帮助，欢迎打赏支持，:smile:

  ![](https://raw.githubusercontent.com/lanrion/my_config/master/imagex/donation_me_wx.jpg)
