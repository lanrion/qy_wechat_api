module QyWechatApi

  class << self

    attr_accessor :config

    def configure
      yield self.config ||= Config.new
    end

    def weixin_redis
      return nil if QyWechatApi.config.nil?
      @redis ||= QyWechatApi.config.redis
    end
  end

  class Config
    attr_accessor :redis, :cache_store, :logger
  end
end
