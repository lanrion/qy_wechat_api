# encoding: utf-8

module QyWechatApi
  module Api
    class Base
      attr_accessor :access_token

      def initialize(access_token)
        @access_token = access_token
      end

      private
        def http_get(url, params={})
          request_url = "#{base_url}/#{url}"
          params = params.merge({access_token: access_token})
          QyWechatApi.http_get_without_token(request_url, params )
        end

        def http_post(url, payload={}, params={})
          request_url = "#{base_url}/#{url}"
          params = params.merge({access_token: access_token})
          QyWechatApi.http_post_without_token(request_url, payload, params)
        end

    end
  end
end
