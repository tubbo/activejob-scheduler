require 'spec_helper'

module ActiveJob
  module Scheduler
    RSpec.describe Schedule do
      subject do
        Schedule.new
      end

      it 'derives a path to the jobs file' do
        expect(subject.path).to eq 'spec/dummy/config/jobs.yml'
      end

      it 'finds event by class name' do
        allow(subject).to respond_to(:yaml).and_return(
          'foo_bar' => {
            'class_name' => 'FooBarJob',
            'every' => '1h'
          }
        )
        expect(subject.find('FooBarJob')).to be_present
      end

      it 'enumerates over all events' do
        allow(subject).to respond_to(:events).and_return([Event.new])
        expect(subject.each).to be_a Iterator
      end

      it 'starts all events simultaneously' do
        allow_any_instance_of(Event).to respond_to(:perform)
        expect(subject.start).to be_any
      end
    end
  end
end
