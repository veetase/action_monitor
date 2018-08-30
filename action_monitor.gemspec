$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "action_monitor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "action_monitor"
  s.version     = ActionMonitor::VERSION
  s.authors     = ["veetase"]
  s.email       = ["veetase@gmail.com"]
  s.homepage    = "http://veetase.cf"
  s.summary     = "Summary of ActionMonitor."
  s.description = "Description of ActionMonitor."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "logstash-logger"

  s.add_development_dependency "sqlite3"
end
