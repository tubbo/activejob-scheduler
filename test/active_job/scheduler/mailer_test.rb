# frozen_string_literal: true

require 'test_helper'

module ActiveJob
  module Scheduler
    class MailerTest < ActiveSupport::TestCase
      test 'add events' do
        refute_empty UserMailer.scheduler_events
        assert_equal 'UserMailer#daily_status', UserMailer.scheduler_events.first[:name]
        refute_equal MultiMailer.scheduler_events, UserMailer.scheduler_events
      end
    end
  end
end
