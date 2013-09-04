Gem::Specification.new do |s|
  s.name        = 'dune'
  s.version     = '0.0.0'
  s.summary     = 'XMPP server'
  s.description = 'Embeddable XMPP server'
  s.authors     = ['Alexander Mankuta']
  s.email       = 'cheba@pointlessone.org'
  s.homepage    = 'http://rubygems.org/gems/dune'
  s.license     = 'MIT'

  s.executables = ['dune']
  s.files       = Dir['Gemfile', 'LICENSE', 'Rakefile', '{bin,lib,spec}/**/*']

  s.add_runtime_dependency 'celluloid-io', '~> 0.15'
  s.add_runtime_dependency 'nokogiri', '~> 1.6.0'
end
