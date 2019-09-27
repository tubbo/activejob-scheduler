# frozen_string_literal: true

namespace :activejob do
  desc 'Enqueue Scheduled Jobs'
  task schedule: [:environment] do
    ActiveJob::Scheduler.start
  end
end
