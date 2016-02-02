require 'spec_helper'

module ActiveJob
  module Scheduler
    RSpec.describe Schedule do
      let :path do
        Rails.root.join('config', 'jobs.yml')
      end

      subject do
        Schedule.new
      end

      before do
        allow(subject).to receive(:yaml).and_return(
          'foo_bar' => {
            'class_name' => 'FooBarJob',
            'every' => '1h'
          }
        )
      end

      it 'derives a path to the jobs file' do
        expect(subject.path).to eq path
      end

      it 'finds event by class name' do
        expect(subject.send(:events).first.job_class_name).to eq 'FooBarJob'
        expect(subject.find_by_name('FooBarJob')).to be_present
      end

      it 'enumerates over all events' do
        expect(subject).to respond_to(:each)
      end

      it 'starts all events simultaneously' do
        allow_any_instance_of(Event).to receive(:perform)
        expect(subject.send(:events)).not_to be_empty
        expect(subject.start).not_to be_empty
      end
    end
  end
end
