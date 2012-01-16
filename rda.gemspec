$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rda/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rda"
  s.version     = Rda::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rda."
  s.description = "TODO: Description of Rda."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.1.3"

  s.add_development_dependency "sqlite3"
end
