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
        ActionMailer::Base.send :include, ActiveJob::Scheduler::Mailer
      end
    end
  end
end
