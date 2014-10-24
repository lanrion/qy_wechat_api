module QyWechatApi
  module Api
    class Department < Base

      # name  是 部门名称。长度限制为1~64个字符
      # parentid  是 父亲部门id。根部门id为1
      # order 否 在父部门中的次序。从1开始，数字越大排序越靠后
      def create(name, parent_id, order=nil)

      end

      # id 是 部门id
      # name  否 更新的部门名称。长度限制为0~64个字符。修改部门名称时指定该参数
      # parentid  否 父亲部门id。根部门id为1
      # order 否 在父部门中的次序。从1开始，数字越大排序越靠后
      def update(id, name=nil, name=nil, parent_id=nil, order=nil)

      end

      def delete(id)

      end

      def list

      end

      private

        def base_url
          "/department"
        end

    end
  end
end
