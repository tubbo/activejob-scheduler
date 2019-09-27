# frozen_string_literal: true

require 'test_helper'

module ActiveJob
  module Scheduler
    class MailerTest < ActiveSupport::TestCase
      test 'add events' do
        refute_empty UserMailer.events
        assert_equal 'UserMailer#daily_status', UserMailer.events.first[:name]
      end
    end
  end
end
