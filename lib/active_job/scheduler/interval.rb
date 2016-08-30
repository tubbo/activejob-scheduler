require 'rufus/scheduler'

module ActiveJob
  module Scheduler
    # Generates a time duration from a given parsed interval value.
    class Interval
      attr_reader :type, :value

      TYPES = %w(cron in at every).freeze

      delegate :==, to: :to_duration

      def initialize(params = {})
        params.each do |type, value|
          @type = type
          @value = value
        end
      end

      def to_duration
        duration = Rufus::Scheduler.send "parse_#{parser}", value, {}

        if duration.is_a? Rufus::Scheduler::CronLine
          return duration.next_time - Time.now
        end

        duration
      end

      def parser
        case type.to_s
        when 'every'
          'duration'
        else
          type
        end
      end
    end
  end
end
