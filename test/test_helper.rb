# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'simplecov'

SimpleCov.start do
  add_filter %r{/test/}
end

require_relative '../test/dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [
  File.expand_path('../test/dummy/db/migrate', __dir__)
]
require 'rails/test_help'
require 'mocha/minitest'

# Filter out the backtrace from minitest while preserving
# the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require 'rails/test_unit/reporter'
Rails::TestUnitReporter.executable = 'bin/test'

Rails.configuration.active_job.queue_adapter = :test

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
  ActionDispatch::IntegrationTest.fixture_path =
    ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path =
    "#{ActiveSupport::TestCase.fixture_path}/files"

  ActiveSupport::TestCase.fixtures :all
end
