# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'qy_wechat_api/version'

Gem::Specification.new do |spec|
  spec.name          = "qy_wechat_api"
  spec.version       = QyWechatApi::VERSION
  spec.authors       = ["lanrion"]
  spec.email         = ["huaitao-deng@foxmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", ">= 1.6.7"
    # A streaming JSON parsing and encoding library for Ruby (C bindings to yajl)
  # https://github.com/brianmario/yajl-ruby
  spec.add_dependency "yajl-ruby", "~> 1.2.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
