require 'spec_helper'

class FooBarJob < ActiveJob::Base
  def perform
    true
  end
end

module ActiveJob
  module Scheduler
    RSpec.describe Event do
      subject do
        Event.new name: 'foo_bar', interval: { every: '3h' }
      end

      it 'finds job class' do
        expect(subject.job_class).to eq(FooBarJob)
      end

      it 'derives interval' do
        expect(subject.interval).to eq(3.hours)
      end

      it 'sets active job' do
        job_class = subject.active_job.instance_variable_get('@job_class')
        delay = subject.active_job.instance_variable_get('@options')[:wait]
        expect(subject.active_job).to be_a(ConfiguredJob)
        expect(job_class).to eq(FooBarJob)
        expect(delay).to eq(3.hours)
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
