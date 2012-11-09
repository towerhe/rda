$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'rda/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rda'
  s.version     = Rda::VERSION
  s.authors     = ['Tower He']
  s.email       = ['towerhe@gmail.com']
  s.homepage    = 'https://github.com/towerhe/rda'
  s.summary     = 'Rails Development Assist'
  s.description = 'Rda(Rails Development Assist) is combined with lots of useful commands which can help you to setup your development enviroments and tools more quickly.'

  s.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'pry', '~> 0.9.9'
  s.add_development_dependency 'rspec', '~> 2.10'
  s.add_development_dependency 'guard', '~> 1.2'
  s.add_development_dependency 'guard-bundler', '~> 1.0'
  s.add_development_dependency 'guard-rspec', '~> 1.1'
  s.add_development_dependency 'fivemat', '~> 1.0'
  if RUBY_PLATFORM =~ /darwin/
    s.add_development_dependency 'ruby_gntp', '~> 0.3'
  end

  s.add_dependency 'activesupport', '>= 3.1'
  s.add_dependency 'thor', '~> 0.15'
  s.add_dependency 'confstruct', '~> 0.2'
end
