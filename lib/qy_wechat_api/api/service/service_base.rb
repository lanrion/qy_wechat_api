# encoding: utf-8
module QyWechatApi
  module Api
    module Service
      class ServiceBase < Api::Base

        attr_accessor :suite_id, :suite_secret, :suite_ticket

        def initialize(suite_id, suite_secret, suite_ticket, options={})
          @suite_id = suite_id
          @suite_secret = suite_secret
          @suite_ticket = suite_ticket
        end

        private
          # 获取应用套件令牌
          # 获取suite_access_token时，还额外需要suite_ticket参数（请永远使用最新接收到的suite_ticket）。suite_ticket由企业号后台定时推送给应用套件，并每十分钟更新。
          # 注2：通过本接口获取的accesstoken不会自动续期，每次获取都会自动更新。
          def get_suite_token
            params = {
              suite_ticket: suite_ticket,
              suite_id: suite_id,
              suite_secret: suite_secret
            }
            QyWechatApi.cache.fetch(suite_id, expires_in: 7100.seconds) do
              QyWechatApi.logger.info("Invoke #{suite_id} get_suite_token to refresh")
              res = QyWechatApi.http_post_without_token(
                request_url("get_suite_token", params),
                params
              )
              QyWechatApi.logger.info(res)
              token = res.result["suite_access_token"]
              if token.blank?
                QyWechatApi.cache.delete(suite_id)
                raise res.errors
              else
                token
              end
            end
          end

          def http_get(url, params={})
            payload.merge!({suite_id: suite_id})
            params.merge!({suite_access_token: get_suite_token})
            QyWechatApi.http_get_without_token(request_url(url, params), params)
          end

          def http_post(url, payload={}, params={})
            payload.merge!({suite_id: suite_id})
            # 获取suite_token时不需要
            if !params.keys.include?(:suite_ticket)
              params.merge!({suite_access_token: get_suite_token})
            end
            QyWechatApi.http_post_without_token(request_url(url, params), payload, params)
          end
      end

    end
  end
end
