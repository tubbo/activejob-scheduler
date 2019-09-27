# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # Thrown when an unsupported type is used as a job class name.
    class NotSupportedError < Error
      def initialize(job_class)
        super "#{job_class} must be an ActionMailer::Base or ActiveJob::Base"
      end
    end
  end
end
