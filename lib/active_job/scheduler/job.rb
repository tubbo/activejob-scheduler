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
        class_attribute :to_event
      end

      class_methods do
        # Add this job to the schedule. Also supports all the
        # rufus-scheduler interval options like `:every` and `:cron`.
        #
        # @param [String] name - Name of the job. Defaults to the class
        # @param [Array] arguments - Arguments to pass to this job
        # @example Job that repeats every hour
        #   class HourlyJob < ApplicationJob
        #     repeat every: '1h'
        #   end
        # @example Job that repeats at the same time every day
        #   class TwoAmJob < ApplicationJob
        #     repeat cron: "0 2 * * * #{Time.zone.tzinfo.identifier}"
        #   end
        def repeat(name: self.name.gsub(/Job\Z/, ''), arguments: [], **interval)
          self.to_event = {
            name: name,
            arguments: arguments,
            interval: interval
          }
        end
      end

      protected

      # Re-enqueue the job after performing if scheduled.
      #
      # @private
      def enqueue_job
        event.enqueue
      end

      # Whether this job is scheduled.
      #
      # @private
      # @return [Boolean]
      def scheduled?
        event.present?
      end

      # Event from the schedule
      #
      # @private
      # @return [ActiveJob::Scheduler::Event]
      def event
        @event ||= Scheduler.events.find(self.class.name)
      end
    end
  end
end
