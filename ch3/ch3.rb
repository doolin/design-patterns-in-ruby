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

  def output_start
    raise "You must override #{__method__} in subclass"
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

  describe 'output_start' do
    it 'expects override' do
      expect {
        described_class.new.output_start
      }.to raise_error("You must override output_start in subclass")
    end
  end
end
