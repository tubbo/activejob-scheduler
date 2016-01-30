module ActiveJob
  module Scheduler
    # An event that has been configured in the schedule to run a
    # background job periodically using +ActiveJob+. This is basically a
    # unit of the configuration that is presented as an object to the
    # rest of the gem. It's also responsible for looking up the job
    # class name and re-enqueuing the job for a later date.
    class Event
      attr_reader :name, :interval, :job_class_name, :arguments, :description

      def initialize(name: '', interval: {}, class_name: '', args: [], description: '')
        @name = name
        @interval = Interval.new interval
        @job_class_name = class_name
        @arguments = args
        @description = description
      end

      # +ActiveJob::Base+ class for the background job scheduled by
      # this event.
      #
      # @return [Class]
      def job_class
        job_class_name.constantize
      rescue LoadError
        raise NotDefinedError, job_class_name
      end

      # Job object that has been delayed by the interval.
      #
      # @return [ActiveJob::Base]
      def active_job
        job_class.set wait: interval
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
