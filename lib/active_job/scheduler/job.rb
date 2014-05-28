require 'active_model'

module ActiveJob::Scheduler
  # A model for use in the scheduler itself that wraps an existing
  # ActiveJob::Base and enqueues it at some point. This is pretty much
  # the holder for each stanza of YAML information as expressed in
  # `config/jobs.yml`.
  class Job
    include ActiveModel::Model

    # Attributes this object supports...
    #
    # - name: the name of the job in YAML
    # - description: A short String description for shell docs
    # - class: The class name of the job, by default derived from name.
    # - interval: How we are describing the interval of passed time
    #   between runs (can be 'every', 'at', 'cron', or 'in')
    #
    # These are all specified in the YAML.
    attr_accessor :name, :description, :class_name, :interval

    # Interval types supported by the scheduler.
    INTERVALS = /at|in|cron|every/

    validates :name, presence: true
    validates :interval, inclusion: { in: INTERVALS }
    validate  :job_class

    # Set up and instantiate this Job object for use with the scheduler.
    # Basically, this wraps the enqueued execution of an `ActiveJob::Base`.
    def initialize(from_attrs={})
      super
    end

    # Find the value of the 'at', 'every', 'cron' or 'in' attribute,
    # whichever one is encountered first.
    def interval_value
      @value ||= attributes[interval]
    end

    # The interval by which this job operates, either 'at', 'every',
    # 'cron' or 'in', whichever is encountered first.
    def interval
      @interval ||= attributes.find { |key, val| key =~ INTERVALS }
    end

    # Class names default to the name of the task.
    def job_class_name
      @job_class_name ||= attributes['class'] || name.classify
    end

    # Description is the humanized name of the task by default.
    def description
      @description ||= name.titleize
    end

    # Enqueue this job with ActiveJob.
    def enqueue
      return false unless valid?
      job_class.enqueue
    end

    private
    def job_class
      job_class_name.constantize
    rescue StandardError
      errors.add :job_class, "'#{job_class_name}' was not found"
    end
  end
end
