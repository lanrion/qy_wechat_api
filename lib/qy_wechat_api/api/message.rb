# encoding: utf-8

module QyWechatApi
  module Api
    class Message < Base

      # 发送文本
      def send_text
      end

      # 发送图片
      def send_image

      end

      # 发送语音
      def send_voice

      end

      # 发送视频
      def send_video

      end

      # 文件信息
      def send_file

      end

      # news消息
      def send_news

      end

      # mpnews
      def send_mpnews

      end

      private

        def base_url
          "/message"
        end

    end
  end
end
