# encoding: utf-8
require "monitor"
module QyWechatApi
  class Client
    include MonitorMixin

    attr_accessor :corp_id, :group_secret, :expired_at # Time.now + expires_in
    attr_accessor :access_token, :redis_key, :storage, :custom_access_token

    def initialize(corp_id, group_secret, options={})
      @custom_access_token = options[:access_token]
      redis_key = options[:redis_key]
      @group_secret = group_secret
      @corp_id   = corp_id
      @redis_key = security_redis_key((redis_key || "qy_#{group_secret}"))
      @storage   = Storage.init_with(self)
      super() # Monitor#initialize
    end

    # return token
    def get_access_token
      return custom_access_token if custom_access_token.present?
      synchronize{ @storage.access_token }
    end

    # 检查appid和app_secret是否有效。
    def is_valid?
      return true if custom_access_token.present?
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

    # 管理素材API
    def material
      Api::Material.new(get_access_token)
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

    # 企业号登录授权
    def auth_login
      Api::AuthLogin.new(nil, corp_id)
    end

    def async_task
      Api::AsyncTask.new(get_access_token, corp_id)
    end

    def agent
      Api::Agent.new(get_access_token)
    end

    def chat
      Api::Chat.new(get_access_token)
    end

    def kf
      Api::Kf.new(get_access_token)
    end

    def shake_around
      Api::ShakeAround.new(get_access_token)
    end

    private

      def security_redis_key(key)
        Digest::MD5.hexdigest(key.to_s).upcase
      end

  end
end
