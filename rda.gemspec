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
  s.description = 'Rda(Rails Development Assist) is combined with lots of useful rake tasks which can help you to setup your development enviroments and tools more quickly.'

  s.files       = `git ls-files`.split('\n')
  s.test_files  = `git ls-files -- {spec,features}/*`.split('\n')
  s.require_paths = ['lib']  

  s.add_dependency 'rails', '>= 3.1'
  s.add_dependency 'thor'
  s.add_dependency 'confstruct'
end
