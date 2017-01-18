# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alma/version'

Gem::Specification.new do |spec|
  spec.name          = "alma"
  spec.version       = Alma::VERSION
  spec.authors       = ["Chad Nelson"]
  spec.email         = ["chad.nelson@temple.edu"]

  spec.summary       = %q{Client for Ex Libris Alma Web Services}
  spec.description   = %q{Client for Ex Libris Alma Web Services}
  spec.homepage      = "https://github.com/tulibraries/alma_rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'ezwadl'


  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
end
