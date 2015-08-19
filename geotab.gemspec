# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geotab/version'

Gem::Specification.new do |spec|
  spec.name          = "geotab"
  spec.version       = Geotab::VERSION
  spec.authors       = ["Jorge Valdivia"]
  spec.email         = ["jvaldivia@fleetio.com"]
  spec.summary       = %q{Wrapper for the Geotab API.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "fakeweb"

  spec.add_dependency "faraday"
  spec.add_dependency "json"
end
