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
        double 'Event', enqueue: TestJob.new
      end

      before do
        allow(Scheduler.events).to receive(:find).with('ActiveJob::Scheduler::TestJob').and_return(event)
      end

      subject { TestJob.new }

      it 'registers after_perform callback only when job is in scheduler' do
        allow(subject).to receive(:scheduled?).and_return true
        expect(subject.perform).to be true
      end

      it 'tests whether job is in scheduler' do
        allow(subject).to receive(:event).and_return double('Event')
        expect(subject).to be_scheduled
      end

      it 'enqueues job for next time' do
        expect(subject.send(:requeue)).to be_a(TestJob)
      end
    end
  end
end
