# frozen_string_literal: true

require 'test_helper'

module ActiveJob
  module Scheduler
    class IntervalTest < ActiveSupport::TestCase
      setup do
        @interval = Interval.new 'every' => '1w'
      end

      test 'has a type' do
        assert_equal 'every', @interval.type
      end

      test 'has a value' do
        assert_equal '1w', @interval.value
      end

      test 'parses given value with rufus' do
        assert_equal 1.week, @interval
      end

      test 'parser' do
        cron = Interval.new 'cron' => '5 4 * * *'

        assert_equal 'cron', cron.parser
      end
    end
  end
end
