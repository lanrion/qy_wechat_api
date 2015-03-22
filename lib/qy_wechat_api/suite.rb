module QyWechatApi
  class Suite
    def self.service(suite_id, suite_secret, suite_ticket)
      Api::Service::Suite.new(suite_id, suite_secret, suite_ticket)
    end
  end
end
