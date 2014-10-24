module QyWechatApi
  module Api
    class User < Base

      # userid  是 员工UserID。对应管理端的帐号，企业内必须唯一。长度为1~64个字符
      # name  是 成员名称。长度为1~64个字符
      # department  否 成员所属部门id列表。注意，每个部门的直属员工上限为1000个
      # position  否 职位信息。长度为0~64个字符
      # mobile  否 手机号码。企业内必须唯一，mobile/weixinid/email三者不能同时为空
      # gender  否 性别。gender=0表示男，=1表示女。默认gender=0
      # tel 否 办公电话。长度为0~64个字符
      # email 否 邮箱。长度为0~64个字符。企业内必须唯一
      # weixinid  否 微信号。企业内必须唯一
      # extattr 否 扩展属性。扩展属性需要在WEB管理端创建后才生效，否则忽略未知属性的赋值
      def create(user_id, name, options={})

      end

      def delete(id)

      end

      private

        def base_url
          "/user"
        end

    end
  end
end
