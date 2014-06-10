require 'spec_helper'
require 'active_job/scheduler/job'

class Worker
  def perform(record)
    # do nothing
  end
end

module ActiveJob::Scheduler
  describe Job do
    subject do
      Job.new \
        name: 'testing',
        every: '30s',
        job_class: 'Worker'
    end

    before do
      allow(subject.send(:jobject)).to receive(:enqueue).and_return true
    end

    it "finds the interval" do
      expect(subject.interval).to eq(:every)
    end

    it "finds the interval value" do
      expect(subject.interval_value).to eq('30s')
    end

    it "finds the job class name" do
      expect(subject.job_class).to eq('Worker')
    end

    it "it finds the description or gets one set" do
      expect(subject.description).to eq('Testing')
    end

    it "enqueues the job with active_job" do
      expect(subject).to be_valid
      expect(subject.enqueue).to be_true
    end
  end
end
