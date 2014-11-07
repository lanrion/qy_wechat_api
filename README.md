开发中...

部门、成员、标签均可以在开发环境调试

```ruby
gem "qy_wechat_api", git: "https://github.com/lanrion/qy_wechat_api.git"
```

**暂未对access_token做缓存处理，为了确保在开发过程不会出现token过期问题，请确保不要使用全局变量做app_client变量。**

## 基本用法

```ruby
app_client = QyWechatApi::Client.new(corpid, corpsecret)

# 创建自定义菜单
# menu_json的生成方法请参考: https://github.com/lanrion/weixin_rails_middleware/wiki/DIY-menu
app_client.menu.create(menu_json, agent_id)

# Oauth 用法
# 先要配置你应用的 可信域名 2458023e.ngrok.com
# state 为开发者自定义参数，可选
app_client.oauth.authorize_url("http://2458023e.ngrok.com", "state")

# 获取code后，获取用户信息
# app_id: 跳转链接时所在的企业应用ID
app_client.oauth.get_user_info("code", "app_id")
```


