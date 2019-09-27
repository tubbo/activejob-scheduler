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

      test 'parses given value with fugit' do
        cron = Interval.new 'cron' => '5 4 * * *'

        assert_equal 1.week, @interval
        assert_equal 'cron', cron.parser
      end

      test 'to duration' do
        cron = Interval.new 'cron' => '5 4 * * *'
        every = Interval.new 'every' => '1d'
        time = Interval.new 'every' => 1.day
        nat = Interval.new 'nat' => 'every day at noon'

        assert_kind_of Float, cron.to_duration
        assert_kind_of Integer, every.to_duration
        assert_kind_of Integer, time.to_duration
        assert_kind_of Float, nat.to_duration
      end
    end
  end
end
