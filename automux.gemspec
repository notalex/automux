# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'automux/version'

Gem::Specification.new do |gem|
  gem.name          = 'automux'
  gem.version       = Automux::Version::STRING
  gem.authors       = ["Alex Johnson"]
  gem.email         = ["notalexjohnson@gmail.com"]
  gem.description   = %[Highly configurable Tmux Automator]
  gem.summary       = %[Automate tmux sessions stored in yaml files using custom recipes]
  gem.homepage      = %[https://github.com/notalex/automux]

  gem.files         = %x[git ls-files].split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)
end
