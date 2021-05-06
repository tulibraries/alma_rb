# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "alma/version"

Gem::Specification.new do |spec|
  spec.name          = "alma"
  spec.version       = Alma::VERSION
  spec.authors       = ["Jennifer Anton", "David Kinzer", "Chad Nelson"]
  spec.email         = ["jennifer.anton@temple.edu", "david.kinzer@temple.edu", "chad.nelson@temple.edu"]

  spec.summary       = "Client for Ex Libris Alma Web Services"
  spec.description   = "Client for Ex Libris Alma Web Services"
  spec.homepage      = "https://github.com/tulibraries/alma_rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ezwadl"
  spec.add_dependency "httparty"
  spec.add_dependency "xml-simple"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rails"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
