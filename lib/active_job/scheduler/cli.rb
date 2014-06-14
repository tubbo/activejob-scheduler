require 'optparse'
require 'rufus/scheduler'

require 'active_job/scheduler/jobs'

module ActiveJob::Scheduler
  # Controller for the schedule via the CLI.
  class CLI
    attr_reader :env, :options

    # A short doc explaining the CLI.
    USAGE = <<-EOF.gsub(/ {6}/, '')
      Usage: activejob-scheduler [options]

      Runs an active_job scheduler process directly (rather than via rake).

    EOF

    # The various options our CLI takes.
    OPTIONS = [
      {
        args: ['-n', '--app-name [APP_NAME]',
               'Application name for procline'],
        callback: ->(options) { ->(n) { options[:app_name] = n } }
      },
      {
        args: ['-B', '--background', 'Run in the background [BACKGROUND]'],
        callback: ->(options) { ->(b) { options[:background] = b } }
      },
      {
        args: ['-D', '--dynamic-schedule',
               'Enable dynamic scheduling [DYNAMIC_SCHEDULE]'],
        callback: ->(options) { ->(d) { options[:dynamic] = d } }
      },
      {
        args: ['-E', '--environment [RAILS_ENV]', 'Environment name'],
        callback: ->(options) { ->(e) { options[:env] = e } }
      },
      {
        args: ['-I', '--initializer-path [INITIALIZER_PATH]',
               'Path to optional initializer ruby file'],
        callback: ->(options) { ->(i) { options[:initializer_path] = i } }
      },
      {
        args: ['-i', '--interval [RESQUE_SCHEDULER_INTERVAL]',
               'Interval for checking if a scheduled job must run'],
        callback: ->(options) { ->(i) { options[:poll_sleep_amount] = i } }
      },
      {
        args: ['-l', '--logfile [LOGFILE]', 'Log file name'],
        callback: ->(options) { ->(l) { options[:logfile] = l } }
      },
      {
        args: ['-F', '--logformat [LOGFORMAT]', 'Log output format'],
        callback: ->(options) { ->(f) { options[:logformat] = f } }
      },
      {
        args: ['-P', '--pidfile [PIDFILE]', 'PID file name'],
        callback: ->(options) { ->(p) { options[:pidfile] = p } }
      },
      {
        args: ['-q', '--quiet', 'Run with minimal output [QUIET]'],
        callback: ->(options) { ->(q) { options[:quiet] = q } }
      },
      {
        args: ['-v', '--verbose', 'Run with verbose output [VERBOSE]'],
        callback: ->(options) { ->(v) { options[:verbose] = v } }
      }
    ].freeze

    # Instantiate a new CLI handler with the given args.
    def initialize(argv, env)
      @env = env
      @args = argv
      @options = option_parser.parse! argv
    end

    # Start the scheduler CLI immediately from given command-line
    # arguments.
    def self.run(argv, env)
      logger.info "Starting ActiveJob Scheduler.."
      new(argv, env).run
    end

    def self.logger
      @logger ||= Logger.new STDOUT
    end

    # Now that we have args, actually begin running the schedule by
    # loading each Job into Rufus::Scheduler. Rufus uses methods like
    # `every` and `cron` to determine what kind of job you're pushing
    # into it, so we use send() to give the Job object the power to make
    # that choice. All we are doing when Rufus fires this block on the
    # scheduled interval is enqueuing the job in your queue of choice.
    def run
      logger.debug "Scheduling jobs with Rufus.."
      jobs.each do |job|
        logger.debug "Found Job :#{job.name}"
        rufus.send(job.interval, job.interval_value) do
          job.enqueue
        end
      end

      logger.debug "Joining the Rufus thread.."
      rufus.join # join this process to the rufus schedule
    end

    private
    def logger
      self.class.logger
    end

    def option_parser
      OptionParser.new do |parser|
        parser.banner = USAGE

        OPTIONS.each do |opt|
          parser.on(*opt[:args], &(opt[:callback].call(options)))
        end
      end
    end

    def jobs
      @jobs ||= Jobs.from_yaml
    end

    def rufus
      @rufus ||= Rufus::Scheduler.new
    end
  end
end
