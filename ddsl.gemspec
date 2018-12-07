# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ddsl/version'

Gem::Specification.new do |spec|
  spec.name          = 'ddsl'
  spec.version       = DDSL::VERSION
  spec.homepage      = 'https://github.com/bilby91/ddsl'
  spec.license       = 'MIT'
  spec.authors       = ['Martin Fernandez']
  spec.email         = ['fmartin91@gmail.com']
  spec.summary       = 'Docker Declarative Specific Language'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ['ddsl']
  spec.require_paths = ['lib']
  spec.add_dependency 'clamp', '~> 1'
  spec.add_dependency 'json', '~> 2'
  spec.add_dependency 'json_schemer', '~> 0.1'
  spec.add_dependency 'transproc', '~> 1'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rubocop', '~> 0.60'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
