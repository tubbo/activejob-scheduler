module ActiveJob
  module Scheduler
    class NotDefinedError
      def initialize(job_class_name)
        super "Job not defined for class name '#{job_class_name}'"
      end
    end
  end
end
