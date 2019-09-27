# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # An event that has been configured in the schedule to run a
    # background job periodically using +ActiveJob+. This is basically a
    # unit of the configuration that is presented as an object to the
    # rest of the gem. It's also responsible for looking up the job
    # class name and re-enqueuing the job for a later date.
    class Event
      attr_reader :name, :interval, :job_class_name, :arguments, :description

      # @param [String] name - Name of this event, usually the job class
      # @param [Hash] interval - When this event should trigger
      # @param [String] class_name - Job class name if different from name
      # @param [Array] arguments - Arguments to pass to the job
      # @param [Array] description - Fancy description for this event
      def initialize(
        name: '',
        interval: {},
        class_name: nil,
        arguments: [],
        description: ''
      )
        @name = name
        @interval = Interval.new interval
        @job_class_name = class_name || "#{name.classify}Job"
        @arguments = arguments
        @description = description
      end

      # +ActiveJob::Base+ class for the background job scheduled by
      # this event.
      #
      # @return [Class]
      def job_class
        job_class_name.constantize
      rescue NameError
        raise NotDefinedError, job_class_name
      end

      # Job object that has been delayed by the interval.
      #
      # @return [ActiveJob::Base]
      def active_job
        job_class.set wait: interval.to_duration
      end

      # Enqueue the job for a later time.
      #
      # @return [ActiveJob::Base]
      def enqueue
        active_job.perform_later(*arguments)
      end

      # Perform the job immediately in the background.
      #
      # @return [ActiveJob::Base]
      def perform
        job_class.perform_later(*arguments)
      end
    end
  end
end
