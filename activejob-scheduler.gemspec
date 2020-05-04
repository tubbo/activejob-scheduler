# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_job/scheduler/version'

Gem::Specification.new do |spec|
  spec.name          = 'activejob-scheduler'
  spec.version       = ActiveJob::Scheduler::VERSION
  spec.authors       = ['Tom Scott']
  spec.email         = ['tscott@weblinc.com']

  spec.summary       = 'Scheduled jobs for ActiveJob.'
  spec.description   = spec.summary.to_s
  spec.homepage      = 'https://github.com/tubbo/activejob-scheduler'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1', '< 3'
  spec.add_development_dependency 'mocha', '~> 1.9'
  spec.add_development_dependency 'rails', '~> 6'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rubocop', '>= 0.49.0'
  spec.add_development_dependency 'simplecov', '~> 0.17'
  spec.add_development_dependency 'sqlite3', '~> 1.4'
  spec.add_development_dependency 'yard', '>= 0.9.20'

  spec.add_dependency 'actionmailer', '> 5', '< 7'
  spec.add_dependency 'activejob', '> 5', '< 7'
  spec.add_dependency 'activesupport', '> 5', '< 7'
  spec.add_dependency 'fugit', '~> 1.3'
  spec.add_dependency 'travis-release', '~> 0'
end
