# encoding: utf-8
# 企业号消息接口说明
module QyWechatApi
  module Api
    class Chat < Base

      # 创建会话
      def create(chat_id, name, owner, users)
        option = {
          chatid: chat_id,
          name: name,
          owner: owner,
          userlist: Array[users]
        }
        http_post("create", option)
      end

      # 获取会话
      def get(chat_id)
        http_get("get", agentid: chat_id)
      end

      # 修改会话信息
      # option: add_user_list, del_user_list, name, owner
      def update(chat_id, operater, option={})
        http_post("update", {chatid: chat_id, op_user: operater}.merge!(option))
      end

      # 退出会话
      def quit(chat_id, operater)
        http_post("quit", {chatid: chat_id, op_user: operater})
      end

      # 清除会话未读状态
      def clear_notify(operater, chat_type, chat_value)
        http_post("clearnotify", {
          op_user: operater, chat: {type: chat_type, id: chat_value}
        })
      end

      # 发消息
      # 注意：如果receiver是单聊，发送对象为userid，否则为chatid
      # 分别生成如下几个方法
      # :send_single_text,
      # :send_single_image,
      # :send_single_file,
      # :send_group_text,
      # :send_group_image,
      # :send_group_file
      RECEIVE_TYPES = ["single", "group"].freeze
      MSG_TYPES = ["text", "image", "file"].freeze
      RECEIVE_TYPES.each do |receive_type|
        MSG_TYPES.each do |type|
          define_method "send_#{receive_type}_#{type}" do |sender, receiver_id, msg|
            http_post("send", {
              receiver: {
                type: receive_type,
                id: receiver_id
              },
              sender: sender,
              msgtype: type,
              type => msg_struct(type, msg)
            })
          end
        end
      end

      # 设置成员新消息免打扰
      # [
      #   {
      #        "userid": "zhangsan",
      #        "status": 0
      #    },
      #    {
      #        "userid": "lisi",
      #        "status": 1
      #    }
      # ]
      def set_mute(mute_users)
        http_post("setmute", {user_mute_list: mute_users})
      end

      private

        # e.g.: text, text_msg
        def msg_struct(type, msg)
          case type
          when "text"
            {content: msg}
          else
            # image, file都为发送media_id
            {media_id: msg}
          end
        end

        def base_url
          "/chat"
        end

    end
  end
end
