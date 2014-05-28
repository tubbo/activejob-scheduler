module ActiveJob::Scheduler
  class Jobs
    include Enumerable

    def initialize(arg)
      @path = from_path
    end

    def self.from_yaml
      new "config/jobs.yml"
    end

    def each
      collection.each { |job| yield job }
    end

    private
    def collection
      params.map { { |attrs| Job.define attrs }
    end

    def params
      @collection ||= YAML::load_file path
    end
  end
end
