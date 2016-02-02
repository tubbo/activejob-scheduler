require 'spec_helper'

module ActiveJob
  RSpec.describe Scheduler do
    it 'loads schedule' do
      allow(YAML).to receive(:load_file).and_return({})
      expect(described_class.events).to be_a Scheduler::Schedule
    end
  end
end
