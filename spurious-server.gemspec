# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spurious/server/version'

Gem::Specification.new do |spec|
  spec.name          = "spurious-server"
  spec.version       = Spurious::Server::VERSION
  spec.authors       = ["Steven Jack"]
  spec.email         = ["stevenmajack@gmail.com"]
  spec.summary       = %q{The server component that the spurious cli client connects to}
  spec.description   = %q{The server component that the spurious cli client connects to}
  spec.homepage      = "https://www.github.com/stevenjack/spurious-server§"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "eventmachine"
  spec.add_runtime_dependency "docker-api"
  spec.add_runtime_dependency "daemons"
  spec.add_runtime_dependency "peach"


end
