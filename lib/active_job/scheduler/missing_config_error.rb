# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # Thrown when the config file doesn't exist.
    class MissingConfigError < Error
      def initialize
        super 'Define config/jobs.yml before using activejob-scheduler'
      end
    end
  end
end
