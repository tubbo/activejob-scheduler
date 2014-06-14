require 'yaml'
require 'active_job/scheduler/job'

module ActiveJob::Scheduler
  class Jobs
    include Enumerable

    attr_reader :path

    def initialize(from_path)
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
      params.keys.map do |name|
        Job.new params[name].merge name: name
      end
    end

    def params
      @collection ||= YAML::load_file path
    end
  end
end
