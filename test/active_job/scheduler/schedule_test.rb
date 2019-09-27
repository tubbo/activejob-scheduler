# frozen_string_literal: true

require 'test_helper'

module ActiveJob
  module Scheduler
    class ScheduleTest < ActiveSupport::TestCase
      setup do
        @schedule = Schedule.new
      end

      test 'derives a path to the jobs file' do
        assert_equal Rails.root.join('config', 'jobs.yml'), @schedule.path
      end

      test 'finds event by class name' do
        @schedule.expects(:yaml).returns(
          'foo_bar' => {
            'class_name' => 'FooBarJob',
            'every' => '1h'
          }
        )

        assert_equal 'FooBarJob', @schedule.send(:events).first.job_class_name
        refute_nil @schedule.find_by_name('FooBarJob')
      end

      test 'enumerates over all events' do
        assert_respond_to @schedule, :each
      end

      test 'starts all events simultaneously' do
        @schedule.expects(:yaml).returns(
          'foo_bar' => {
            'class_name' => 'FooBarJob',
            'every' => '1h'
          }
        )

        refute_empty @schedule.send(:events)
        refute_empty @schedule.start
      end

      test 'read from yaml configuration' do
        assert_kind_of Event, @schedule.find_by_name('YamlTestJob')

        bogus = Schedule.new
        bogus.expects(:path).returns('/tmp/foo.yml')

        assert_raises(ActiveJob::Scheduler::MissingConfigError) do
          bogus.find_by_name('YamlTestJob')
        end
      end
    end
  end
end
