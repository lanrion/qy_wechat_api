# encoding: utf-8
# 登录授权流程说明
module QyWechatApi
  module Api
    class AuthLogin < Base

      # 服务商引导用户进入登录授权页 服务可以在自己的网站首页中放置“微信企业号登录”的入口，引导用户（指企业号系统管理员者）进入登录授权页。
      # 网址为: https://qy.weixin.qq.com/cgi-bin/loginpage?corp_id=xxxx&redirect_uri=xxxxx&state=xxxx
      # 服务商需要提供corp_id，跳转uri和state参数，其中uri需要经过一次urlencode作为参数，state用于服务商自行校验session，防止跨域攻击。
      # 授权回调时会传递：
      # auth_code=xxx&expires_in=600，auth_code用于get_login_info(获取企业号管理员登录信息)接口使用
      def auth_login_url(redirect_uri, state="qy_wechat")
        require "erb"
        redirect_uri = ERB::Util.url_encode(redirect_uri)
        "#{QyWechatApi::SUITE_ENDPOINT}/loginpage?corp_id=#{corp_id}&redirect_uri=#{redirect_uri}&state=#{state}"
      end

      # 获取应用提供商凭证
      # https://qyapi.weixin.qq.com/cgi-bin/service/get_provider_token
      def get_provider_token(provider_secret)
        cache_key = "auth_login-#{corp_id}-get_provider_token"
        QyWechatApi.cache.fetch(cache_key, expires_in: 7100.seconds) do
          payload = {corpid: corp_id, provider_secret: provider_secret}
          url = base_url("get_provider_token")
          res = QyWechatApi.http_post_without_token(url, payload)
          token = res.result["provider_access_token"]
          if token.blank?
            QyWechatApi.cache.delete(cache_key)
            raise res.errors
          else
            token
          end
        end
      end

      # 通过传递provider_access_token,获取企业号管理员登录信息
      # https://qyapi.weixin.qq.com/cgi-bin/service/get_login_info?provider_access_token=enLSZ5xxxxxxJRL
      def get_login_info(auth_code, provider_access_token)
        url = base_url("get_login_info", {provider_access_token: provider_access_token})
        QyWechatApi.http_post_without_token(url, {auth_code: auth_code})
      end

      # 通过传递provider_secret,获取企业号管理员登录信息
      def get_login_info_by_secret(auth_code, provider_secret)
        token = get_provider_token(provider_secret)
        get_login_info(auth_code, token)
      end

      # 获取登录企业号官网的url
      # target可以是：agent_setting、send_msg、contact、3rd_admin
      def get_login_url(ticket, provider_token, target, agentid=nil)
        url = base_url("get_login_url", {provider_access_token: provider_token})
        params = {
          login_ticket: ticket,
          target: target
        }
        params.merge!(agentid: agentid) if agentid.present?
        QyWechatApi.http_post_without_token(url, params)
      end

      private

        def base_url(api, params={})
          params = params.to_query
          params = "?#{params}" if params.present?
          "/service/#{api}#{params}"
        end

    end
  end
end
