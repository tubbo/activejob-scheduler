# frozen_string_literal: true

require 'test_helper'

module ActiveJob
  class SchedulerTest < ActiveSupport::TestCase
    test 'events' do
      assert_kind_of Scheduler::Schedule, Scheduler.events
    end
  end
end
