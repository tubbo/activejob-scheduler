require 'spec_helper'

module ActiveJob
  module Scheduler
    RSpec.describe Event do
      class FooBarJob < ActiveJob::Base
        def perform
          true
        end
      end

      subject do
        Event.new name: 'foo_bar', interval: { every: '3h' }
      end

      it 'finds job class' do
        expect(subject.job_class).to eq(FooBarJob)
      end

      it 'derives interval' do
        expect(subject.interval).to eq(interval)
      end

      it 'sets active job' do
        expect(subject.active_job).to be_a(FooBarJob)
      end

      it 'enqueues job for later' do
        expect(subject.enqueue).to be_a(FooBarJob)
      end

      it 'performs job immediately' do
        expect(subject.perform).to be_a(FooBarJob)
      end
    end
  end
end
