# encoding: utf-8
module QyWechatApi
  module Api
    class AsyncTask < Base

      CALLBACK_KEYS = ["url", "token", "encodingaeskey"].freeze

      BATCH_METHOD = ["sync_user", "replace_user", "replace_party"].freeze

      # 邀请成员关注
      def invite_user(callback, invite_info={})
        check_callback(callback)
        invite_info = invite_info["callback"] = callback
        http_post("inviteuser", invite_info)
      end

      # 增量更新成员
      # 全量覆盖成员
      # 全量覆盖部门
      BATCH_METHOD.each do |m_name|
        define_method m_name do |callback, media_id|
          check_callback(callback)
          payload = {media_id: media_id, callback: callback}
          http_post(m_name.sub("_", ""), payload)
        end
      end

      # 获取异步任务结果
      def get_result(job_id)
        payload = {jobid: job_id}
        http_post("getresult", payload)
      end

      private

        def check_callback(callback)
          if (callback.keys - CALLBACK_KEYS).present?
            raise "callback param must include #{CALLBACK_KEYS.join(',')}"
          end
        end

        def base_url
          "/batch"
        end
    end
  end
end
