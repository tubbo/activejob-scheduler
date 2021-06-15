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

        assert_equal 'FooBarJob', @schedule.send(:scheduler_events).first.job_class_name
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
        @schedule.expects(:scheduler_events_from_jobs).returns([])

        refute_empty @schedule.send(:scheduler_events)
        refute_empty @schedule.start
      end

      test 'read from yaml configuration' do
        assert_kind_of Event, @schedule.find_by_name('YamlTestJob')
      end

      test 'read from dsl configuration' do
        assert_kind_of Event, @schedule['DslTestJob']
      end

      test 'return nothing when job not found' do
        @schedule.expects(:path).returns('/tmp/foo.yml')

        assert_nil @schedule.find_by_name('YamlTestJob')
      end
    end
  end
end
