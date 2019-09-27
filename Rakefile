# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'travis/release/task'
require 'rake/testtask'

APP_RAKEFILE = File.expand_path('test/dummy/Rakefile', __dir__)

load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

RuboCop::RakeTask.new :lint

YARD::Rake::YardocTask.new :doc

Travis::Release::Task.new

task default: %i[test build doc]
