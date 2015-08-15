# encoding: utf-8

module QyWechatApi
  module Api
    class Base
      attr_accessor :access_token, :corp_id

      def initialize(access_token, corp_id=nil)
        @access_token = access_token
        @corp_id = corp_id
      end

      private

        def http_get(url, params={})
          params = params.merge({access_token: access_token})
          QyWechatApi.http_get_without_token(request_url(url, params), params )
        end

        def http_post(url, payload={}, params={})
          params = params.merge({access_token: access_token})
          QyWechatApi.http_post_without_token(request_url(url, params), payload, params)
        end

        def base_url
          ""
        end

        def request_url(url, params={})
          waive_base_url = params.delete(:waive_base_url)
          if waive_base_url
            url
          else
            # 使用基础 +base_url+进行拼接
            "#{base_url}/#{url}"
          end
        end

    end
  end
end
