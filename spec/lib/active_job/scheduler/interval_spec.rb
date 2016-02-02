require 'spec_helper'

module ActiveJob
  module Scheduler
    RSpec.describe Interval do
      subject do
        Interval.new 'every' => '1w'
      end

      it 'has a type' do
        expect(subject.type).to eq 'every'
      end

      it 'has a value' do
        expect(subject.value).to eq '1w'
      end

      it 'parses given value with rufus' do
        expect(subject).to eq(1.week)
      end
    end
  end
end
