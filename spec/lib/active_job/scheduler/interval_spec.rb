require 'spec_helper'

module ActiveJob
  module Scheduler
    RSpec.describe Interval do
      subject do
        Interval.new 'every' => '3h'
      end

      it 'has a type' do
        expect(subject.type).to eq 'every'
      end

      it 'has a value' do
        expect(subject.value).to eq '3h'
      end

      it 'parses given value with rufus' do
        expect(subject).to eq(3.hours)
      end

      it 'must have a proper type' do
        expect { Interval.new('foo' => 'bar') }.to raise_error(ArgumentError)
        expect { Interval.new(nil => 'bar') }.to raise_error(ArgumentError)
      end

      it 'must have a value' do
        expect { Interval.new('foo' => nil) }.to raise_error(ArgumentError)
      end
    end
  end
end
