# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # An event that has been configured in the schedule to run a
    # background job periodically using +ActiveJob+. This is basically a
    # unit of the configuration that is presented as an object to the
    # rest of the gem. It's also responsible for looking up the job
    # class name and re-enqueuing the job for a later date.
    class Event
      attr_reader :name, :interval, :job_class_name, :arguments

      # @param [String] name - Name of this event, usually the job class
      # @param [Hash] interval - When this event should trigger
      # @param [String] class_name - Job class name if different from name
      # @param [Array] arguments - Arguments to pass to the job
      def initialize(
        name: '',
        interval: {},
        class_name: nil,
        arguments: [],
        **options
      )
        @name = name
        @interval = Interval.new interval
        @job_class_name = class_name || "#{name.camelize}Job"
        @arguments = arguments
        @mail = options[:mail]
        @each = options[:each]
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
      def jobs
        return Array.wrap(job_class.set(wait: interval.to_duration)) if single?

        @each.call.map do |item|
          args = arguments + [item]
          [job_class.set(wait: interval.to_duration), args]
        end
      end

      # Whether to call `@each` and iterate
      def single?
        @each.blank?
      end

      # Enqueue the job for a later time.
      #
      # @return [ActiveJob::Base]
      def enqueue
        if job_class < ActiveJob::Base
          enqueue_jobs
        elsif job_class < ActionMailer::Base
          enqueue_mails
        else
          raise TypeError, "#{job_class} is not supported by #{self}"
        end
      end

      private

      def enqueue_jobs
        jobs.each { |job, args| job.perform_later(*args) }
      end

      def enqueue_mails
        return job_class.send(@mail, *arguments) if single?

        @each.call.each do |item|
          args = arguments + [item]
          job_class.send(@mail, *args)
                   .deliver_later(wait: interval.to_duration)
        end
      end
    end
  end
end
