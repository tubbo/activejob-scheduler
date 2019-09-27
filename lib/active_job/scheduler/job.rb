# frozen_string_literal: true

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
        after_perform :enqueue_job, if: :scheduled?
        after_enqueue :mark_as_enqueued, if: :scheduled?
      end

      def enqueue_job
        Scheduler.events.enqueue(event)
      end

      def scheduled?
        event.present?
      end

      def event
        @event ||= Scheduler.events.find(self.class.name)
      end
    end
  end
end
