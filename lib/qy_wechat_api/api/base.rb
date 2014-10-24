module QyWechatApi
  module Api
    class Base
      attr_accessor :access_token

      def initialize(access_token)
        @access_token = access_token
      end

    end
  end
end
