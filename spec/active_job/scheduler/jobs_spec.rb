require 'spec_helper'
require 'active_job/scheduler/jobs'

module ActiveJob::Scheduler
  describe Jobs do
    let :fixture_config do
      File.expand_path('../../../fixtures/jobs.yml', __FILE__)
    end

    subject { Jobs.new fixture_config }

    it "reads from a yaml file on disk" do
      expect(subject.path).to eq(fixture_config)
    end

    it "defines jobs from each params stanza it sees" do
      expect(subject.send(:collection).first).to be_a Job
    end

    it "iterates over the collection as an enumerable" do
      expect(subject).to respond_to :each
    end
  end
end
