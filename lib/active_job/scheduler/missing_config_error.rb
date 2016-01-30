module ActiveJob
  module Scheduler
    class MissingConfigError
      def initialize
        super "Define config/jobs.yml before using activejob-scheduler"
      end
    end
  end
end
