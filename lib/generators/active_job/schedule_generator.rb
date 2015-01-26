require 'rails/generators/base'

module ActiveJob
  class ScheduleGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_schedule_yaml
      template 'jobs.yml', 'config/jobs.yml'
    end
  end
end
