# frozen_string_literal: true

require 'test_helper'

module ActiveJob
  module Scheduler
    class EventTest < ActiveJob::TestCase
      setup do
        @event = Event.new name: 'foo_bar', interval: { every: '3h' }
      end

      test 'finds job class' do
        assert_equal FooBarJob, @event.job_class
      end

      test 'derives interval' do
        assert_equal 3.hours, @event.interval
      end

      test 'sets active job' do
        assert_kind_of ConfiguredJob, @event.jobs.first
        assert_equal 3.hours, @event.jobs.first
                                    .instance_variable_get('@options')[:wait]
      end

      test 'enqueues job for later' do
        assert_kind_of FooBarJob, @event.enqueue
      end

      test 'throw error when job class not defined' do
        bogus = Event.new name: 'bogus'

        assert_raises(NotDefinedError) { bogus.job_class }
      end

      test 'throw error when enqueuing unsupported type' do
        bogus = Event.new class_name: 'Object'

        assert_raises(TypeError) { bogus.enqueue }
      end

      test 'schedule jobs' do
        assert_enqueued_jobs 2, only: MultiJob do
          Scheduler.events.find_by_name('MultiJob').schedule
        end
      end

      test 'schedule mails' do
        assert_enqueued_jobs 2, only: ActionMailer::DeliveryJob do
          Scheduler.events.find_by_name('MultiMailer').schedule
        end
      end
    end
  end
end
