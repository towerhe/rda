$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rda/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rda"
  s.version     = Rda::VERSION
  s.authors     = ["Tower He"]
  s.email       = ["towerhe@gmail.com"]
  s.homepage    = "https://github.com/towerhe/rda"
  s.summary     = "Rails Development Assist"
  s.description = "Rda(Rails Development Assist) is combined with lots of useful rake tasks which can help you to setup your development enviroments and tools more quickly."

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_paths = ["lib"]  

  s.add_dependency "rails", "~> 3.1.3"
  s.add_dependency "thor"
  s.add_dependency "confstruct"

  s.add_development_dependency "pry"
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "guard-rspec"
  if RUBY_PLATFORM =~ /darwin/
    s.add_development_dependency "ruby_gntp"
  elsif RUBY_PLATFORM =~ /linux/
    s.add_development_dependency "libnotify"
  end
end
