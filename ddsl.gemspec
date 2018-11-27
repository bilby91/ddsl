# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ddsl/version'

Gem::Specification.new do |spec|
  spec.name          = 'ddsl'
  spec.version       = DDSL::VERSION
  spec.authors       = ['Martin Fernandez']
  spec.email         = ['fmartin91@gmail.com']
  spec.summary       = 'Docker Declarative Specific Language'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ['ddsl']
  spec.require_paths = ['lib']
  spec.add_dependency 'clamp'
  spec.add_dependency 'json-schema'
  spec.add_dependency 'transproc'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
