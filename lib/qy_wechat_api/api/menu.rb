# encoding: utf-8
module QyWechatApi
  module Api
    class Menu < Base

      def create(menu, agent_id)
        menu = JSON.load(menu) if menu.is_a?(String)
        http_post("create", menu, {agentid: agent_id})
      end

      def delete(agent_id)
        http_get("delete", {agentid: agent_id})
      end

      def get(agent_id)
        http_get("get", {agentid: agent_id})
      end

      private

        def base_url
          "/menu"
        end

    end
  end
end
