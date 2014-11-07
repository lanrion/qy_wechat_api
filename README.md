开发中...

部门、成员、标签均可以在开发环境调试

```
gem "qy_wechat_api", git: "https://github.com/lanrion/qy_wechat_api.git"
```

**暂未对access_token做缓存处理，为了确保在开发过程不会出现token过期问题，请确保不要使用全局变量做client**

## 基本用法
```ruby
client = QyWechatApi::Client.new(QyWechatApi.corpid, QyWechatApi.corpsecret)

# 创建自定义菜单
# menu_json的生成方法请参考: https://github.com/lanrion/weixin_rails_middleware/wiki/DIY-menu
client.menu.create(menu_json, agent_id)

```


