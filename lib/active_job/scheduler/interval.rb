require 'rufus/scheduler'

module ActiveJob
  module Scheduler
    class Interval
      attr_reader :type, :value

      TYPES = %w(cron in at every)

      delegate :==, to: :to_i

      def initialize(params = {})
        params.each do |type, value|
          @type = type
          @value = value
        end

        unless @type.present?  && TYPES.include?(@type)
          fail ArgumentError, "'#{@type}' must be of type #{TYPES}"
        end

        unless @value.present?
          fail ArgumentError, "Cannot schedule with nil value"
        end
      end

      def to_i
        Rufus::Scheduler.send "parse_#{type}", value
      end
    end
  end
end
