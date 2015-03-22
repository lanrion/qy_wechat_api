# encoding: utf-8

module QyWechatApi
  class Client
    attr_accessor :corp_id, :group_secret, :expired_at # Time.now + expires_in
    attr_accessor :access_token, :redis_key, :storage

    def initialize(corp_id, group_secret, redis_key=nil)
      @corp_id      = corp_id
      @group_secret = group_secret
      @redis_key    = security_redis_key((redis_key || "qy_" + group_secret))
      @storage      = Storage.init_with(self)
    end

    # return token
    def get_access_token
      @storage.access_token
    end

    # 检查appid和app_secret是否有效。
    def is_valid?
      @storage.valid?
    end

    # 管理部门API
    def department
      Api::Department.new(get_access_token)
    end

    # 管理成员API
    def user
      Api::User.new(get_access_token)
    end

    # 管理标签API
    def tag
      Api::Tag.new(get_access_token)
    end

    # 管理多媒体文件API
    def media
      Api::Media.new(get_access_token)
    end

    def message
      Api::Message.new(get_access_token)
    end

    def menu
      Api::Menu.new(get_access_token)
    end

    def oauth
      Api::Oauth.new(get_access_token, corp_id)
    end

    def js
      Api::Js.new(get_access_token, corp_id)
    end

    private

      def security_redis_key(key)
        Digest::MD5.hexdigest(key.to_s).upcase
      end

  end
end
