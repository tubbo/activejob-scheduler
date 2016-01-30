require 'spec_helper'

describe ActiveJob::Scheduler do
  it 'has a version number' do
    expect(ActiveJob::Scheduler::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
