# frozen_string_literal: true

require 'test_helper'

module ActiveJob
  module Scheduler
    class JobTest < ActiveJob::TestCase
      class TestJob < ActiveJob::Base
        include Job

        def perform(*_args)
          true
        end
      end

      test 'enqueues job for next time' do
        @event = Event.new(
          name: 'active_job/scheduler/job_test/test',
          interval: {
            every: '1d'
          }
        )

        Scheduler.events
                 .expects(:find)
                 .with(TestJob.name)
                 .returns(@event)

        assert_enqueued_with job: TestJob, at: 1.day.from_now do
          assert TestJob.perform_now
        end
      end
    end
  end
end
