# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # An error occurring within ActiveJob::Scheduler's operation.
    class Error < StandardError
    end
  end
end
