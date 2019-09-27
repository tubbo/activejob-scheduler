# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # Look up the schedule at +config/jobs.yml+ and create a collection
    # of +ActiveJob::Scheduler::Job+ objects to be used throughout the
    # library.
    #
    # @api public
    class Schedule
      include Enumerable

      # Path to the config file on disk.
      #
      # @attr_reader [String]
      attr_reader :path

      # Iterator for the collection of job objects.
      #
      # @return [Iterator]
      delegate :each, to: :events

      def initialize
        @path = Rails.root.join 'config', 'jobs.yml'
      end

      # Find a job by its +class_name+
      #
      # @param [String] name - Class name of the job
      # @return [ActiveJob::Scheduler::Job] or +nil+ if it can't be
      # found.
      def find_by_name(by_class_name)
        find do |event|
          event.job_class_name == by_class_name
        end
      end

      # Enqueue all configured background jobs immediately.
      #
      # @return [Array<ActiveJob::Base>]
      def start
        events.map(&:perform)
      end

      private

      # All events scheduled in the jobs.yml file.
      #
      # @private
      # @return [Array<ActiveJob::Scheduler::Job>]
      def events
        @events ||= yaml.map do |name, options|
          Event.new(
            name: name,
            class_name: options['class_name'],
            arguments: options['args'],
            description: options['description'],
            interval: options.slice(Interval::TYPES)
          )
        end
      end

      # Read the jobs.yml file as a Hash.
      #
      # @private
      # @return [Hash]
      def yaml
        @yaml ||= YAML.load_file path
      rescue YAML::LoadError
        raise MissingConfigError
      end
    end
  end
end
