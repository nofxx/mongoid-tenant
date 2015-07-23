# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'mongoid/tenant/version'

Gem::Specification.new do |s|
  s.name        = 'mongoid-tenant'
  s.version     = Mongoid::Tenant::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Marcos Piccinini']
  s.homepage    = 'http://github.com/nofxx/mongoid-tenant'
  s.summary     = 'Multi Database/Tenants models for Mongoid documents.'
  s.description = 'Mongoid Tenant with multiple database per client.'
  s.license     = 'MIT'

  s.rubyforge_project = 'mongoid-tenant'
  s.add_dependency 'mongoid', '> 4.0.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
