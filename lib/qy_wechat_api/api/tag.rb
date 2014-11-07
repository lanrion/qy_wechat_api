# encoding: utf-8

module QyWechatApi
  module Api
    class Tag < Base

      def create(name)
        http_post("create", {tagname: name})
      end

      # tagid 是 标签ID
      # tagname 是
      def update(id, name)
        http_post("update", {tagid: id, tagname: name})
      end

      def delete(id)
        http_get("delete", {tagid: id})
      end

      def get(id)
        http_get("get", {tagid: id})
      end

      # tagid 是 标签ID
      # userlist  是 企业员工ID列表
      def add_tag_users(id, user_ids)
        raise "企业员工ID列表 必须为数组" if !user_ids.is_a?(Array)
        http_post("addtagusers", {tagid: id, userlist: user_ids})
      end

      # tagid 是 标签ID
      # userlist  是 企业员工ID列表
      def delete_tag_users(id, user_ids)
        raise "企业员工ID列表 必须为数组" if !user_ids.is_a?(Array)
        http_post("deltagusers", {tagid: id, userlist: user_ids})
      end

      def list
        http_get("list")
      end

      private

        def base_url
          "/tag"
        end

    end
  end
end
