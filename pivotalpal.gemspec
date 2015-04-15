# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pivotalpal/version'

Gem::Specification.new do |spec|
  spec.name          = "pivotalpal"
  spec.version       = Pivotalpal::VERSION
  spec.authors       = ["Zach Davis"]
  spec.email         = ["zach@castironcoding.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = "Does some stuff"
  spec.description   = "Does some stuff"
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'user_config', '~> 0.0', '>= 0.0.4'
  spec.add_runtime_dependency 'tracker_api', '~> 0.2.7'
  spec.add_runtime_dependency 'command_line_reporter', '>=3.0'

end
