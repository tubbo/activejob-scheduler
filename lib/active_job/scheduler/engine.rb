module ActiveJob
  module Scheduler
    # Rails app integration. Loads Requeue concern into ActiveJob::Base
    # and schedules all periodic jobs.
    class Engine < Rails::Engine
      isolate_namespace ActiveJob::Scheduler
      config.eager_load_namespaces << ActiveJob::Scheduler

      ActiveSupport.on_load :active_job do
        ActiveJob::Base.send :include, ActiveJob::Scheduler::Job
      end

      initializer 'active_job.scheduler' do
        ActiveSupport.on_load :active_job do
          ActiveJob::Scheduler.events.start
        end
      end
    end
  end
end
