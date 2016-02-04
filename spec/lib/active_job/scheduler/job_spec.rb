require 'spec_helper'

module ActiveJob
  module Scheduler
    RSpec.describe Job do
      class TestJob < ActiveJob::Base
        include Job

        def perform(*_args)
          true
        end
      end

      let :event do
        Event.new(
          name: 'test_job',
          every: '1d'
        )
      end

      before do
        allow(
          Scheduler.events
        ).to(
          receive(:find)
          .with('ActiveJob::Scheduler::TestJob')
          .and_return(event)
        )
      end

      it 'enqueues job for next time' do
        assert_enqueued_with job: TestJob do
          expect(TestJob.perform_later).to be_a(TestJob)
        end
      end
    end
  end
end
