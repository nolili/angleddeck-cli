lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'angled_deck/version'

Gem::Specification.new do |spec|
  spec.name          = "angleddeck-cli"
  spec.version       = AngledDeck::VERSION
  spec.authors       = ["Soutaro Matsumoto"]
  spec.email         = ["matsumoto@soutaro.com"]
  spec.summary       = "AngledDeck Command Line Utility"
  spec.description   = "AngledDeck Command Line Utility"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "activesupport", "~> 4.2"
  spec.add_dependency "aws-sdk", "~> 2.2"
  spec.add_dependency "httpclient", "~> 2.7"
end
