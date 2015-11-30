# encoding: utf-8
# 企业客服服务
module QyWechatApi
  module Api
    class Kf < Base

      # 发送客服消息
      # http://qydev.weixin.qq.com/wiki/index.php?title=企业客服接口说明
      def send(payload)
        http_post("send", payload)
      end

      private

        def base_url
          "/kf"
        end

    end
  end
end
