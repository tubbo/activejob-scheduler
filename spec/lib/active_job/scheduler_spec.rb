require 'spec_helper'

module ActiveJob
  RSpec.describe Scheduler do
    it 'loads schedule' do
      expect(described_class.events).to be_a Schedule
    end
  end
end
