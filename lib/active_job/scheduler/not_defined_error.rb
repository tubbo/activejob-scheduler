module ActiveJob
  module Scheduler
    # Thrown when a job is not defined for the given class_name.
    class NotDefinedError
      def initialize(job_class_name)
        super "Job not defined for class name '#{job_class_name}'"
      end
    end
  end
end
