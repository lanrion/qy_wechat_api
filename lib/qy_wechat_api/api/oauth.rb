# encoding: utf-8
module QyWechatApi
  module Api
    class Oauth < Base

      # appid 是 企业的CorpID
      # redirect_uri  是 授权后重定向的回调链接地址，请使用urlencode对链接进行处理
      # response_type 是 返回类型，此时固定为：code
      # scope 是 应用授权作用域，此时固定为：snsapi_base
      # state 否 重定向后会带上state参数，企业可以填写a-zA-Z0-9的参数值
      # #wechat_redirect 是微信终端使用此参数判断是否需要带上身份信息
      # https://open.weixin.qq.com/connect/oauth2/authorize?appid=CORPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect
      def authorize_url(redirect_uri, state="qy_wechat")
        require "erb"
        redirect_uri = ERB::Util.url_encode(redirect_uri)
        QyWechatApi.open_endpoint("/connect/oauth2/authorize?appid=#{corp_id}&redirect_uri=#{redirect_uri}&response_type=code&scope=snsapi_base&state=#{state}#wechat_redirect")
      end

      # 根据code获取成员信息
      # https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token=ACCESS_TOKEN&code=CODE&agentid=AGENTID
      def get_user_info(code, agent_id)
        http_get("user/getuserinfo", {code: code, agentid: agent_id})
      end

    end
  end
end
