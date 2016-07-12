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
          interval: {
            every: '1d'
          }
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
        expect(TestJob.perform_later).to be_a(TestJob)
        expect(TestJob).to have_been_enqueued
      end
    end
  end
end
