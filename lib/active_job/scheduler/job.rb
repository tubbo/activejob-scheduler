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
    attr_accessor :name, :description, :job_class, :interval, :interval_value
    attr_reader :attributes

    # Interval types supported by the scheduler.
    INTERVALS = %w(at in cron every)

    validates :name, presence: true
    validates :interval, presence: true
    validates :interval_value, presence: true

    # Set up and instantiate this Job object for use with the scheduler.
    # Basically, this wraps the enqueued execution of an `ActiveJob::Base`.
    def initialize(from_attrs={})
      @interval, @interval_value = from_attrs.select { |attr, value|
        INTERVALS.include? "#{attr}"
      }.first.to_a.flatten
      from_attrs.delete @interval
      @attributes = from_attrs
      super
    end

    # Description is the humanized name of the task by default.
    def description
      @description ||= name.titleize
    end

    # The job class defaults to a classified version of the name, if
    # it's not provided.
    def job_class
      @job_class ||= name.classify
    end

    # Enqueue this job with ActiveJob.
    def enqueue
      return false unless valid?
      jobject.enqueue
    end

    private
    def jobject
      job_class.constantize
    rescue StandardError
      errors.add :job_class, "'#{job_class}' was not found"
    end
  end
end
