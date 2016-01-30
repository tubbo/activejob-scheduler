require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"

RSpec::Core::RakeTask.new :test

RuboCop::RakeTask.new :lint

YARD::Rake::YardocTask.new :doc

task default: %i(lint test build)
