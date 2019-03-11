# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slackdown/version"

Gem::Specification.new do |spec|
  spec.name          = "slackdown"
  spec.version       = Slackdown::VERSION
  spec.authors       = ["Bob Lail"]
  spec.email         = ["bob.lailfamily@gmail.com"]

  spec.summary       = %q{Converts Markdown text to Slack's simplified markdown}
  spec.description   = %q{A converter for Kramdown that converts GitHub-Flavored Markdown to Slack's simplified Markdown}
  spec.homepage      = "https://github.com/houston/slackdown"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "kramdown", "~> 2.0.0"
  spec.add_dependency "kramdown-parser-gfm", "~> 1.0.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "minitest-reporters-turn_reporter"
  spec.add_development_dependency "shoulda-context"
  spec.add_development_dependency "pry"
end
