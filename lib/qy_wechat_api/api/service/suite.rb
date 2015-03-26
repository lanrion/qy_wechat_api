# encoding: utf-8
module QyWechatApi
  module Api
    module Service
      class Suite < ServiceBase

        # 获取预授权码
        # 该API用于获取预授权码。预授权码用于企业号授权时的应用提供商安全验证。
        def get_pre_auth_code(appid=[])
          http_post("get_pre_auth_code", {appid: appid})
        end

        # 获取企业号的永久授权码
        # 该API用于使用临时授权码换取授权方的永久授权码，并换取授权信息、企业access_token。

        # 注：临时授权码使用一次后即失效
        def get_permanent_code(auth_code)
          http_post("get_permanent_code", {auth_code: auth_code})
        end

        # 获取企业号的授权信息
        # 该API用于通过永久授权码换取企业号的授权信息。 永久code的获取，是通过临时授权码使用get_permanent_code 接口获取到的permanent_code。
        def get_auth_info(auth_corpid, code)
          params = {auth_corpid: auth_corpid, permanent_code: code}
          http_post("get_auth_info", params)
        end

        # 获取企业号应用
        # 该API用于获取授权方的企业号某个应用的基本信息，包括头像、昵称、帐号类型、认证类型、可见范围等信息
        def get_agent(auth_corpid, code, agent_id)
          params = {
            auth_corpid: auth_corpid,
            permanent_code: code,
            agentid: agent_id
          }
          http_post("get_agent", params)
        end

        # 该API用于设置授权方的企业应用的选项设置信息，如：地理位置上报等。注意，获取各项选项设置信息，需要有授权方的授权。
        def set_agent(auth_corpid, permanent_code, agent_info)
          params = {
            auth_corpid: auth_corpid,
            permanent_code: permanent_code,
            agent: agent_info
          }
          http_post("set_agent", params)
        end

        # 应用提供商在取得企业号的永久授权码并完成对企业号应用的设置之后，便可以开始通过调用企业接口（详见企业接口文档）来运营这些应用。其中，调用企业接口所需的access_token获取方法如下。
        def get_corp_token(auth_corpid, permanent_code)
          params = {
            auth_corpid: auth_corpid,
            permanent_code: permanent_code,
          }
          http_post("get_corp_token", params)
        end

        # https://qy.weixin.qq.com/cgi-bin/loginpage?suite_id=$suite_id$&pre_auth_code=$pre_auth_code$&redirect_uri=$redirect_uri$&state=$state$
        def auth_url(code, uri, state="suite")
          params = {
            suite_id: suite_id,
            pre_auth_code: code,
            redirect_uri: uri,
            state: state
          }.to_query
          "#{QyWechatApi::SUITE_ENDPOINT}/loginpage?#{params}"
        end

        private

          def base_url
            "/service"
          end

      end
    end
  end
end
