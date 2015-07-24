# encoding: utf-8
# 管理企业号应用
module QyWechatApi
  module Api
    class Agent < Base

      def set(info)
        http_post("set", info)
      end

      def get(agent_id)
        http_get("get", agentid: agent_id)
      end

      def list
        http_get("list")
      end

      private

        def base_url
          "/agent"
        end

    end
  end
end
