# encoding: utf-8

module QyWechatApi
  module Api
    class Department < Base

      # name  是 部门名称。长度限制为1~64个字符
      # parentid  是 父亲部门id。根部门id为1
      # order 否 在父部门中的次序。从1开始，数字越大排序越靠后
      # id  否  部门id，整型。指定时必须大于1，不指定时则自动生成
      def create(name, parent_id, order=nil, id=nil)
        payload = {name: name}
        payload[:parentid] = parent_id
        payload[:order] = order if not order.nil?
        payload[:id] = id if id.is_a?( Integer ) && id > 1
        http_post("create", payload)
      end

      # id 是 部门id
      # name  否 更新的部门名称。长度限制为0~64个字符。修改部门名称时指定该参数
      # parentid  否 父亲部门id。根部门id为1
      # order 否 在父部门中的次序。从1开始，数字越大排序越靠后
      def update(id, name=nil, parent_id=nil, order=nil)
        payload = {id: id}
        payload[:name] = name if not name.nil?
        payload[:parentid] = parent_id if not parent_id.nil?
        payload[:order] = order if not order.nil?
        http_post("update", payload)
      end

      def delete(id)
        http_get("delete", id: id)
      end

      def list(id = nil)
        if id
          http_get("list", id: id)
        else
          http_get("list")
        end
      end

      private

        def base_url
          "/department"
        end

    end
  end
end
