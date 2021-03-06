# frozen_string_literal: true

require 'yaml'
require 'active_job'
require 'active_support/all'
require 'active_job/scheduler/version'
require 'active_job/scheduler/engine'
require 'fugit'

# A framework for declaring jobs and making them run on a variety of
# queuing backends.
module ActiveJob
  # Scheduled periodic jobs with +ActiveJob+.
  module Scheduler
    extend ActiveSupport::Autoload

    autoload :Error
    autoload :Event
    autoload :Job
    autoload :Mailer
    autoload :Schedule
    autoload :Interval
    autoload :MissingConfigError
    autoload :NotDefinedError
    autoload :NotSupportedError

    class << self
      delegate :start, to: :events

      # A schedule of all periodic job events.
      #
      # @return [ActiveJob::Scheduler::Schedule]
      def events
        @events ||= Schedule.new
      end
    end
  end
end
