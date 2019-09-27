# frozen_string_literal: true

require 'test_helper'

module ActiveJob
  module Scheduler
    class MailerTest < ActiveSupport::TestCase
      test 'add events' do
        refute_empty UserMailer.events
        assert_equal 'UserMailer#daily_status', UserMailer.events.first[:name]
        refute_equal MultiMailer.events, UserMailer.events
      end
    end
  end
end
