# encoding: utf-8

module QyWechatApi
  class Client
    attr_accessor :corp_id, :group_secret, :expired_at # Time.now + expires_in
    attr_accessor :access_token

    def initialize(corp_id, group_secret, redis_key=nil)
      @corp_id     = corp_id
      @group_secret = group_secret
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

    private
      def get_access_token
        self.access_token ||= get_token.result["access_token"]
      end

      # 获取token
      def get_token
        params = {corpid: corp_id, corpsecret: group_secret}
        QyWechatApi.http_get_without_token("/gettoken", params)
      end

  end
end
