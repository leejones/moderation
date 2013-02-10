# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moderation/version'

Gem::Specification.new do |gem|
  gem.name          = "moderation"
  gem.version       = Moderation::VERSION
  gem.authors       = ["Lee Jones"]
  gem.email         = ["scribblethink@gmail.com"]
  gem.description   = %q{Moderation stores only the most recent data based on a limit you set.}
  gem.summary       = %q{Certain types of data are good to keep around, but only in moderation. Moderation makes it easy to keep only the most recent amount of data you care about. Persistent storage is backed by Redis.}
  gem.homepage      = "http://github.com/leejones/moderation"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  gem.add_dependency('multi_json', '~> 1.0')
  gem.add_dependency('redis-namespace', '~> 1.0')

  gem.add_development_dependency('rspec', '~> 2.0')
  gem.add_development_dependency('pry')
end

