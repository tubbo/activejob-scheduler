# frozen_string_literal: true

module ActiveJob
  module Scheduler
    # Rails app integration. Loads Requeue concern into ActiveJob::Base
    # and schedules all periodic jobs.
    class Engine < Rails::Engine
      isolate_namespace ActiveJob::Scheduler
      config.eager_load_namespaces << ActiveJob::Scheduler

      initializer 'active_job.scheduler' do
        ActiveJob::Base.send :include, ActiveJob::Scheduler::Job
      end
    end
  end
end
