# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'link_shortener/version'

Gem::Specification.new do |spec|
  spec.name          = "link_shortener"
  spec.version       = LinkShortener::VERSION
  spec.authors       = ["Ruslan Korolev"]
  spec.email         = ["great1672@gmail.com"]

  spec.summary       = %q{Generate short links}
  spec.description   = %q{Generate short links via rebrandly}
  spec.homepage      = "https://github.com/rusikf/link_shortener"
  spec.license       = "GNU"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'rollbar'
  spec.add_runtime_dependency 'addressable'
  spec.add_runtime_dependency 'rest-client'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'climate_control'
  spec.add_development_dependency 'webmock'
end
