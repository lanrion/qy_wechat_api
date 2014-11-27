# encoding: utf-8

module QyWechatApi
  class Storage

    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def self.init_with(client)
      if QyWechatApi.weixin_redis.nil?
        ObjectStorage.new(client)
      else
        RedisStorage.new(client)
      end
    end

    def valid?
      authenticate["valid"]
    end

    def authenticate
      auth_result = http_get_access_token
      auth = false
      if auth_result.is_ok?
        set_access_token_for_client(auth_result.result)
        auth = true
      end
      {"valid" => auth, "handler" => auth_result}
    end

    def refresh_token
      handle_valid_exception
      set_access_token_for_client
    end

    def access_token
      refresh_token if token_expired?
    end

    def token_expired?
      raise NotImplementedError, "Subclasses must implement a token_expired? method"
    end

    def set_access_token_for_client(access_token_infos=nil)
      token_infos = access_token_infos || http_get_access_token.result
      client.access_token = token_infos["access_token"]
      client.expired_at   = Time.now.to_i + token_infos["expires_in"].to_i
    end

    def http_get_access_token
      QyWechatApi.http_get_without_token("/gettoken", authenticate_headers)
    end

    def authenticate_headers
      {corpid: client.corp_id, corpsecret: client.group_secret}
    end

    private

      def handle_valid_exception
        auth_result = authenticate
        if !auth_result["valid"]
          result_handler = auth_result["handler"]
          raise Errors::ValidAccessTokenException, result_handler.full_error_message
        end
      end

      def weixin_redis
        QyWechatApi.weixin_redis
      end
  end
end
