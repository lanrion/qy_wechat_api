# encoding: utf-8

module QyWechatApi
  module Api
    class User < Base

      # 创建成员
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
        user = {userid: user_id}
        user[:name] = name
        user.merge!(options)
        http_post("create", user)
      end

      # 更新成员
      def update(user_id, options={})
        user = {userid: user_id}
        user.merge!(options)
        http_post("update", user)
      end

      # 删除成员
      def delete(id)
        http_get("delete", {userid: id})
      end

      # 批量删除成员
      def batch_delete(user_ids)
        http_post("batchdelete", {useridlist: user_ids})
      end

      # 获取成员
      def get(id)
        http_get("get", {userid: id})
      end

      # 获取部门成员
      # department_id 是 获取的部门id
      # fetch_child 否 1/0：是否递归获取子部门下面的成员
      # status  否 0获取全部员工，1获取已关注成员列表，2获取禁用成员列表，4获取未关注成员列表。status可叠加
      def simple_list(department_id, fetch_child=nil, status=nil)
        params = {department_id: department_id}
        params[:fetch_child] = fetch_child if not fetch_child.nil?
        params[:status] = status if not status.nil?
        http_get("simplelist", params)
      end

      # 获取部门成员(详情)
      def full_list(department_id, fetch_child=nil, status=nil)
        params = {department_id: department_id}
        params[:fetch_child] = fetch_child if not fetch_child.nil?
        params[:status] = status if not status.nil?
        http_get("list", params)
      end

      # 邀请成员关注
      def send_invitation(user_id, tips="")
        payload = {userid: user_id, invite_tips: tips}
        http_post("/invite/send", payload, {waive_base_url: true})
      end

      # userid转换成openid接口
      def covert_to_open_id(user_id, agent_id="")
        payload = {userid: user_id}
        payload.merge!(agentid: agent_id) if agent_id.present?
        http_post("convert_to_openid", payload)
      end

      # openid转换成userid接口
      def covert_to_user_id(open_id)
        http_post("convert_to_userid", {openid: open_id})
      end

      private

        def base_url
          "/user"
        end

    end
  end
end
