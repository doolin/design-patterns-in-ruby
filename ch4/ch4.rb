#!/usr/bin/env ruby

require 'rspec/autorun'

# Page 77: Strategy pattern.

class Formatter
  def output_report(title, text)
    raise "You must override #{__method__}"
  end
end

RSpec.describe Formatter do
  describe '#output_report' do
    it 'raises' do
      expect {
        described_class.new.output_report('foo', 'bar')
      }.to raise_error("You must override output_report")
    end
  end
end
