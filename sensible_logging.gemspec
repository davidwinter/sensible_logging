# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensible_logging/version'

Gem::Specification.new do |spec|
  spec.name          = 'sensible_logging'
  spec.version       = SensibleLogging::VERSION
  spec.authors       = ['David Winter', 'Mark Sta Ana', 'Anthony King']
  spec.email         = ['i@djw.me']

  spec.summary       = 'Sensible logging defaults for your Sinatra app'
  spec.homepage      = 'https://github.com/davidwinter/sensible_logging'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.required_ruby_version = '>= 2.6'

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '>= 5.2', '< 7.0'
  spec.add_runtime_dependency 'rack', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 2.2.0'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'puma', '~> 5.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.22.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.8.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sinatra', '~> 2.0'
end
