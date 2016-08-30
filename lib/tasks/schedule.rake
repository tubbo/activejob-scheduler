
namespace :activejob do
  desc 'Schedule the tasks listed in jobs.yml'
  task :schedule => [:environment] do
    ActiveJob::Scheduler.events.enqueue
  end
end
