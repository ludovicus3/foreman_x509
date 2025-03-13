require File.expand_path('lib/foreman_x509/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'foreman_x509'
  s.version     = ForemanX509::VERSION
  s.metadata    = { 'is_foreman_plugin' => 'true' }
  s.license     = 'GPL-3.0'
  s.authors     = ['Jason Galens']
  s.email       = ['jason@galensfamily.org']
  s.homepage    = 'https://github.com/ludovicus3/foreman_x509'
  s.summary     = 'Manage certificates used by Foreman internally'
  # also update locale/gemspec.rb
  s.description = 'Certificate Management for Foreman'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md', 'package.json']
  s.test_files = Dir['test/**/*'] + Dir['webpack/**/__tests__/*.js']

  s.required_ruby_version = '>= 2.7', '< 4'

  s.add_development_dependency 'rdoc'
end
