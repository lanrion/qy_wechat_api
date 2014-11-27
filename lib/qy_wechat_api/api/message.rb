# encoding: utf-8

module QyWechatApi
  module Api
    class Message < Base

      # 发送文本
      def send_text(users, parties, tags, agent_id, content, safe=0)
        params = common_params("text", agent_id, users, parties, tags, safe)
        params.merge!({text: {content: content}})
        http_post("send", params)
      end

      # 发送图片
      def send_image(users, parties, tags, agent_id, media_id, safe=0)
        params = common_params("image", agent_id, users, parties, tags, safe)
        params.merge!({image: {media_id: media_id}})
        http_post("send", params)
      end

      # 发送语音
      def send_voice(users, parties, tags, agent_id, media_id, safe=0)
        params = common_params("voice", agent_id, users, parties, tags, safe)
        params.merge!({voice: {media_id: media_id}})
        http_post("send", params)
      end

      # 发送视频
      # media_options: {title: "title", description: "Description"}
      def send_video(users, parties, tags, agent_id, media_id, media_options={}, safe=0)
        params = common_params("video", agent_id, users, parties, tags, safe)
        params.merge!({
          video: {
            media_id: media_id,
            title: media_options["title"],
            description: media_options["description"],
          }
        })
        http_post("send", params)
      end

      # 文件信息
      def send_file(users, parties, tags, agent_id, media_id, safe=0)
        params = common_params("file", agent_id, users, parties, tags, safe)
        params.merge!({file: {media_id: media_id}})
        http_post("send", params)
      end

      # news消息
      # "articles":[
      #    {
      #        "title": "Title",
      #        "description": "Description",
      #        "url": "URL",
      #        "picurl": "PIC_URL"
      #    },
      #    {
      #        "title": "Title",
      #        "description": "Description",
      #        "url": "URL",
      #        "picurl": "PIC_URL"
      #    }
      #  ]
      def send_news(users, parties, tags, agent_id, articles, safe=0)
        params = common_params("news", agent_id, users, parties, tags, safe)
        params.merge!({news: {articles: articles}})
        http_post("send", params)
      end

      # mpnews
      # articles":[
      #            {
      #                "title": "Title",
      #                "thumb_media_id": "id",
      #                "author": "Author",
      #                "content_source_url": "URL",
      #                "content": "Content",
      #                "digest": "Digest description",
      #                "show_cover_pic": "0"
      #            },
      #            {
      #                "title": "Title",
      #                "thumb_media_id": "id",
      #                "author": "Author",
      #                "content_source_url": "URL",
      #                "content": "Content",
      #                "digest": "Digest description",
      #                "show_cover_pic": "0"
      #            }
      #        ]
      def send_mpnews(users, parties, tags, agent_id, articles, safe=0)
        params = common_params("mpnews", agent_id, users, parties, tags, safe)
        params.merge!({mpnews: {articles: articles}})
        http_post("send", params)
      end

      private

        def base_url
          "/message"
        end

        # 通用函数
        def common_params(msg_type, agent_id, users=[], parties=[], tags=[], safe=0)
          params = {
            touser: join(users),
            toparty: join(parties),
            msgtype: msg_type,
            agentid: agent_id,
            totag: join(tags)
          }
          params.merge!({safe: safe}) if msg_type != "news"
          params
        end

        def join(array, split="|")
          return array if array.is_a?(String)
          array.join(split)
        end

    end
  end
end
