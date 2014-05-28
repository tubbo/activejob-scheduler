require 'active_job/scheduler/cli'
require 'rake/tasklib'

module ActiveJob::Scheduler
  # Run the scheduler as a Rake task, and preload the Rails environment.
  #
  # Example Task:
  #
  #   ActiveJob::Scheduler::Task.new :schedule
  #
  # Example Shell Command:
  #
  #   rake schedule
  #
  # The task can also be pre-loaded with a task called `schedule:setup`.
  class Task < Rake::TaskLib
    attr_reader :name

    def initialize(with_name=:schedule)
      @name = with_name
      yield self if block_given?
      define
    end

    def define
      namespace name do
        task :setup

        task :run do
          ActiveJob::Scheduler::Cli.run ARGV, ENV
        end
      end

      desc "Run the ActiveJob::Scheduler"
      task name => ["#{name}:setup", "#{name}:run"]
    end
  end
end
