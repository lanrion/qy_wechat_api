开发中...

部门、成员、标签、自定义菜单、Oauth2 接口均可以在开发环境调试

**有问题请及时提issue**

```ruby
gem "qy_wechat_api", git: "https://github.com/lanrion/qy_wechat_api.git"
```

**暂未对access_token做缓存处理，为了确保在开发过程不会出现token过期问题，请不要使用全局变量存储app_client。**

# 基本用法

请务必结合：http://qydev.weixin.qq.com/wiki/index.php 理解以下API参数使用。

## 初始化

```ruby
app_client = QyWechatApi::Client.new(corpid, corpsecret)
```

## 部门

```ruby
app_client.department.create(name, parent_id, order=nil)
app_client.department.update(id, name, parent_id, order=nil)
app_client.department.delete(id)
app_client.department.list
```

## 成员

```ruby
app_client.user.create(user_id, name, options={})
app_client.user.update(user_id, options={})
app_client.user.delete(user_id)
app_client.user.get(user_id)
app_client.user.simple_list(department_id, fetch_child=nil, status=nil)
```

## 标签

```ruby
app_client.tag.create(name)
app_client.tag.update(id, name)
app_client.tag.delete(id)
app_client.tag.get(id)
app_client.tag.add_tag_users(id, user_ids)
app_client.tag.delete_tag_users(id, user_ids)
app_client.tag.list
```

## 自定义菜单

menu_json的生成方法请参考:
https://github.com/lanrion/weixin_rails_middleware/wiki/DIY-menu

```ruby
app_client.menu.delete(menu_json, app_id)
app_client.menu.create(app_id)
app_client.menu.get(app_id)
```

## Oauth2用法

先要配置你应用的 可信域名 `2458023e.ngrok.com`
state 为开发者自定义参数，可选

```ruby
# 生成授权url
app_client.oauth.authorize_url("http://2458023e.ngrok.com", "state")

# 获取code后，获取用户信息
# app_id: 跳转链接时所在的企业应用ID
app_client.oauth.get_user_info("code", "app_id")
```


