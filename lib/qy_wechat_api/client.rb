module QyWechatApi
  class Client
    attr_accessor :app_id, :corp_secret, :expired_at # Time.now + expires_in
    attr_accessor :access_token

    def initialize(corp_id, corp_secret, redis_key=nil)
      @corp_id     = corp_id
      @corp_secret = corp_secret
    end

    # 获取token
    def get_token
      params = {corp_id: corp_id, corpsecret: corp_secret}
      RestClient.get("#{ENDPOINT_URL}/gettoken", {params: params})
    end

    # 管理部门API
    def department
      Api::Department.new(access_token: access_token)
    end

    # 管理成员API
    def user
      Api::User.new(access_token: access_token)
    end

    # 管理标签API
    def tag
      Api::Tag.new(access_token: access_token)
    end

    # 管理多媒体文件API
    def media
      Api::Media.new(access_token: access_token)
    end

    def message
      Api::Message.new(access_token: access_token)
    end

  end
end
