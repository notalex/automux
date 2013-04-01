# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'automux/version'

Gem::Specification.new do |gem|
  gem.name          = "automux"
  gem.version       = Automux::Version::STRING
  gem.authors       = ["Alex Johnson"]
  gem.email         = ["notalexjohnson@gmail.com"]
  gem.description   = %[Automating Tmux Configuration]
  gem.summary       = %[Automux can automate tmux sessions by reading configuration from yaml files]
  gem.homepage      = "https://github.com/notalex/automux"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
