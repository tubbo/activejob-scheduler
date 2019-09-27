# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # Generates a time duration from a given parsed interval value.
    class Interval
      attr_reader :type, :value

      # All interval types in options.
      TYPES = %w[cron in at every nat].freeze

      delegate :==, to: :to_duration

      def initialize(params = {})
        params.each do |type, value|
          @type = type
          @value = value
        end
      end

      # Parse this interval with `Fugit`
      def to_duration
        return value if value.is_a? Integer

        duration = Fugit.public_send("do_parse_#{parser}", value)

        return duration.next_time - Time.current if duration.is_a? Fugit::Cron

        duration.to_sec
      end

      # Discover which `Rufus::Scheduler` parser to use by checking the
      # type.
      #
      # @return [String]
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
