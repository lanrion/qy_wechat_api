module QyWechatApi
  module Api
    class Tag < Base

      def create(name)

      end

      def update(id, name)

      end

      def delete(id)

      end

      def tag(id)

      end

      # tagid 是 标签ID
      # userlist  是 企业员工ID列表
      def add_tag_users(id, user_ids)

      end

      # tagid 是 标签ID
      # userlist  是 企业员工ID列表
      def delete_tag_users(id, user_ids)

      end

      def list

      end

      private

        def base_url
          "/tag"
        end

    end
  end
end
