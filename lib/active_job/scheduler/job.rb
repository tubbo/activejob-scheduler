module ActiveJob
  module Scheduler
    # Extensions to +ActiveJob::Base+ which re-enqueue jobs that have
    # been configured in the schedule. Jobs configured in the schedule
    # are immediately fired when the app restarts and set to perform
    # later as soon as they complete for every subsequent run after
    # that. Jobs are only "requeued" when an +Event+ matching their
    # class name is found in the scheduler.
    module Job
      extend ActiveSupport::Concern

      included do
        around_perform :requeue, if: :scheduled?
      end

      protected

      # Test if a scheduled job can be found, and if so, it will be
      # re-enqueued when completed.
      #
      # @protected
      # @return [Boolean]
      def scheduled?
        event.present?
      end

      # Re-enqueue the current job if it's scheduled.
      #
      # @protected
      # @return [ActiveJob::Base]
      def requeue
        event.enqueue
      end

      private

      # Find a scheduled job by its class name.
      #
      # @private
      # @return [ActiveJob::Scheduler::Job]
      def event
        @event ||= Scheduler.events.find self.class.name
      end
    end
  end
end
