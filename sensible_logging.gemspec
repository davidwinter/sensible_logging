# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensible_logging/version'

Gem::Specification.new do |spec|
  spec.name          = 'sensible_logging'
  spec.version       = SensibleLogging::VERSION
  spec.authors       = ['David Winter', 'Mark Sta Ana', 'Anthony King']
  spec.email         = ['sre@madetech.com']

  spec.summary       = 'Sensible logging defaults for your Sinatra app'
  spec.homepage      = 'https://github.com/madetech/sensible_logging'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '~> 5.2'
  spec.add_runtime_dependency 'rack', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'puma', '~> 3.12'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.65.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.32.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sinatra', '~> 2.0'
end
