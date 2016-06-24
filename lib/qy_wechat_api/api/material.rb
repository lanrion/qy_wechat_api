# encoding: utf-8

module QyWechatApi
  module Api
    class Material < Base

      MATERIAL_TYPES = ["image", "voice", "video", "file"].freeze

      # 上传永久图文素材
      # https://qyapi.weixin.qq.com/cgi-bin/material/add_mpnews?access_token=ACCESS_TOKEN
      def add_mpnews(agent_id, articles=[])
        payload = {agentid: agent_id, mpnews: {articles: articles}}
        http_post("add_mpnews", payload)
      end

      # 修改永久图文素材
      def update_mpnews(agent_id, media_id, articles=[])
        payload = {agentid: agent_id, media_id: media_id, mpnews: {articles: articles}}
        http_post("update_mpnews", payload)
      end


      # 上传其他类型永久素材
      # https://qyapi.weixin.qq.com/cgi-bin/material/add_material?agentid=AGENTID&type=TYPE&access_token=ACCESS_TOKEN
      def add_material(agent_id, type, file)
        check_masterial_type(type)
        http_post("add_material", {media: file}, {type: type, agentid: agent_id})
      end

      # 删除永久素材
      # https://qyapi.weixin.qq.com/cgi-bin/material/del?access_token=ACCESS_TOKEN&agentid=AGENTID&media_id=MEDIA_ID
      def del(agent_id, media_id)
        http_get("del", {agent_id: agent_id, media_id: media_id})
      end

      # 获取素材总数
      # https://qyapi.weixin.qq.com/cgi-bin/material/get_count?access_token=ACCESS_TOKEN&agentid=AGENTID
      def get_count(agent_id)
        http_get("get_count", agentid: agent_id)
      end

      # 获取素材列表
      # https://qyapi.weixin.qq.com/cgi-bin/material/batchget?access_token=ACCESS_TOKEN
      def list(agent_id, type, offset, count=20)
        check_masterial_type(type)
        http_post("batchget", {agentid: agent_id, type: type, offset: offset, count: count})
      end

      private

        def base_url
          "/material"
        end

        def check_masterial_type(type)
          if !type.to_s.in?(MATERIAL_TYPES)
            raise "#{type} must one of #{MATERIAL_TYPES.join(',')}"
          end
        end

    end
  end
end
