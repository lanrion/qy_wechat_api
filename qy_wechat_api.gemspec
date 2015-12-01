# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'qy_wechat_api/version'

Gem::Specification.new do |spec|
  spec.name          = "qy_wechat_api"
  spec.version       = QyWechatApi::VERSION
  spec.authors       = ["lanrion"]
  spec.email         = ["huaitao-deng@foxmail.com"]
  spec.summary       = %q{企业微信高级API Ruby版本}
  spec.description   = %q{企业微信高级API Ruby版本}
  spec.homepage      = "https://github.com/lanrion/qy_wechat_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", ">= 1.6.7"
    # A streaming JSON parsing and encoding library for Ruby (C bindings to yajl)
  # https://github.com/brianmario/yajl-ruby
  spec.add_dependency "yajl-ruby", ">= 1.2.0"
  spec.add_dependency "activesupport"

  spec.add_dependency "carrierwave", ">= 0.10.0"
  spec.add_dependency 'mini_magick', '>= 3.7.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
