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
        # Default name for the scheduled event.
        #
        # @return [String] class name without "Job" at the end
        def event_name
          name.gsub(/Job\Z/, '')
        end

        # Add this job to the schedule. Supports all the Fugit interval
        # options like `:every`, `:at`, and `:cron`, but also takes a
        # special string argument form for natural language duration
        # parsing.
        #
        # @param [String] nat - (optional) Natural language interval.
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
        # @example Natural language example
        #   class NoonJob < ApplicationJob
        #     repeat 'every day at noon', arguments: ['foo']
        #   end
        def repeat(
          nat = nil,
          name: event_name,
          arguments: [],
          each: nil,
          **interval
        )
          interval = { nat: nat } if nat.present?
          self.to_event = {
            name: name,
            arguments: arguments,
            interval: interval,
            each: each
          }.compact
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
        @event ||= Scheduler.events.find_by_name(self.class.name)
      end
    end
  end
end
