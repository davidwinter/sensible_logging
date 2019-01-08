
lib = File.expand_path('../lib', __FILE__)
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

  spec.add_runtime_dependency 'rack', '~> 2.0'
  spec.add_runtime_dependency 'activesupport', '~> 5.2'

  spec.add_development_dependency 'sinatra', '~> 2.0'
  spec.add_development_dependency 'puma', '~> 3.12'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.12.2'
end
