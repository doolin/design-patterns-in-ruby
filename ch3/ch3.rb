#!/usr/bin/env ruby

require 'rspec/autorun'

# The Template method

class Report
  def initialize
    @title = 'monthly report'
    @text = [ 'Things are going', 'really, really well']
  end

  # I would have named this simply 'output', or possibly
  # 'write'.
  def output_report
    report = ""
    report << '<html>'
    report << '  <head>'
    report << "    <title>#{@title}</title>"
    report << '  </head>'
    report << '  <body>'
    @text.each { |line| report << "      <p>#{line}</p>" }
    report << '  </body>'
    report << '</html>'
  end

  def output_report
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end

  # __method__ is ruby method unavailable in 2007.
  def output_start
    raise "You must override #{__method__} in subclass"
  end

  def output_head
    raise "You must override #{__method__} in subclass"
  end

  def output_body_start
    raise "You must override #{__method__} in subclass"
  end

  def output_body
    raise "You must override #{__method__} in subclass"
  end

  def output_body_end
    raise "You must override #{__method__} in subclass"
  end

  def output_end
    raise "You must override #{__method__} in subclass"
  end
end

class HTMLReport < Report
  def output_start
    '<html>'
  end
end

RSpec.describe HTMLReport do
  describe '#output_start' do
    it '' do
      expect(described_class.new.output_start).to eq '<html>'
    end
  end
end

RSpec.describe Report do
  describe '.new' do
    it 'instantiates' do
      expect(Report.new).not_to be nil
    end
  end

  describe '#output_report' do
    xit'' do
      expect(described_class.new.output_report).to match(/<title>monthly report<\/title>/)
    end
  end

  ['output_start', 'output_head', 'output_body_start'].each do |method|
    it "raises NoMethodError for #{method}" do
      expect {
        described_class.new.send method
      }.to raise_error("You must override #{method} in subclass")
    end
  end
end
