require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'travis/release/task'

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)

load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

RSpec::Core::RakeTask.new :test

RuboCop::RakeTask.new :lint

YARD::Rake::YardocTask.new :doc

Travis::Release::Task.new

task default: %i(lint test build doc)
