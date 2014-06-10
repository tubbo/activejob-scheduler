# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_job/scheduler/version'

Gem::Specification.new do |spec|
  spec.name          = "activejob-scheduler"
  spec.version       = ActiveJob::Scheduler::VERSION
  spec.authors       = ["Tom Scott"]
  spec.email         = ["tscott@telvue.com"]
  spec.summary       = %q{A scheduling apparatus for ActiveJob based on Rufus.}
  spec.description   = %q{A scheduling apparatus for ActiveJob based on Rufus. Resque::Scheduler for everyone!}
  spec.homepage      = "http://github.com/tubbo/activejob-scheduler"
  spec.license       = "NCSA"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency 'activejob'
  spec.add_dependency 'rufus-scheduler'
  spec.add_dependency 'activemodel'
end
