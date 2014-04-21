# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitcasa/version'

Gem::Specification.new do |spec|
  spec.name          = "bitcasa"
  spec.version       = Bitcasa::VERSION
  spec.authors       = ["cnosuke"]
  spec.email         = ["cnosuke@gmail.com"]
  spec.summary       = "Bitcasa API gems"
  spec.description   = "Yet another Bitcasa API library for Ruby"
  spec.homepage      = "https://github.com/cnosuke/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
