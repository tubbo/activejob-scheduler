# frozen_string_literal: true

require 'test_helper'

class FooBarJob < ActiveJob::Base
  def perform
    true
  end
end

module ActiveJob
  module Scheduler
    class EventTest < ActiveSupport::TestCase
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
        assert_kind_of ConfiguredJob, @event.active_job
        assert_equal 3.hours, @event.active_job
                                    .instance_variable_get('@options')[:wait]
      end

      test 'enqueues job for later' do
        assert_kind_of FooBarJob, @event.enqueue
      end

      test 'performs job immediately' do
        assert_kind_of FooBarJob, @event.perform
        assert @event.perform
      end

      test 'throw error when job class not defined' do
        bogus = Event.new name: 'bogus'

        assert_raises(NotDefinedError) { bogus.job_class }
      end
    end
  end
end
