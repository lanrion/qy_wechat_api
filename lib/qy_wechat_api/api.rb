require "qy_wechat_api/api/base"
require "qy_wechat_api/api/service/service_base"
Dir["#{File.dirname(__FILE__)}/api/**/*.rb"].each do |path|
  require path
end

