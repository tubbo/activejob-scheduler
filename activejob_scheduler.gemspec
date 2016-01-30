$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "activejob_scheduler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activejob_scheduler"
  s.version     = ActivejobScheduler::VERSION
  s.authors     = ["Tom Scott"]
  s.email       = ["tscott@weblinc.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActivejobScheduler."
  s.description = "TODO: Description of ActivejobScheduler."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5.1"

  s.add_development_dependency "pg"
end
