# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fast_food/version'

Gem::Specification.new do |gem|
  gem.name          = "fast_food"
  gem.version       = FastFood::VERSION
  gem.authors       = ["Richard Biffin"]
  gem.email         = ["rkjb@me.com"]
  gem.description   = %q{Provides quick and dirty server provisioning and app deployment using Chef and Capistrano}
  gem.summary       = %q{Provides quick and dirty server provisioning and app deployment using Chef and Capistrano}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'  
  
  gem.add_runtime_dependency "capistrano"
  gem.add_runtime_dependency "capistrano-ext"
  gem.add_runtime_dependency "rvm-capistrano"
  gem.add_runtime_dependency 'chef', '~> 0.10.8'
end
