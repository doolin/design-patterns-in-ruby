#!/usr/bin/env ruby

require 'rspec/autorun'

require 'pry'

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
    report = ''
    report << output_start
    report << output_head
    report << output_body_start
    report << output_body
    report << output_body_end
    report << output_end
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
    @text.reduce('') do |a, line|
      a << output_line(line)
    end
  end

  def output_line(line)
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

  def output_end
    '</html>'
  end

  def output_head
    head = ''
    head << '  <head>'
    head << "    <title>#{@title}</title>"
    head << '  </head>'
  end

  def output_body_start
    '<body>'
  end

  def output_line(line)
    "    <p>#{line}</p>"
  end

  def output_body_end
    '</body>'
  end
end

class PlainTextReport < Report
  def output_start
    ''
  end

  def output_head
    "**** #{@title} ****"
  end

  def output_body_start
    ''
  end

  def output_body_end
    ''
  end

  def output_line(line)
    line
  end

  def output_end
    ''
  end
end

RSpec.describe PlainTextReport do
  describe '#output_start' do
    it '' do
      expect(described_class.new.output_start).to eq ''
    end
  end

  describe '#output_head' do
    it '' do
      expect(described_class.new.output_head).to eq "**** monthly report ****"
    end
  end

  describe '#output_body_start' do
    it '' do
      expect(described_class.new.output_body_start).to eq ''
    end
  end

  describe '#output_body_end' do
    it '' do
      expect(described_class.new.output_body_end).to eq ''
    end
  end

  describe '#output_end' do
    it '' do
      expect(described_class.new.output_end).to eq ''
    end
  end
end

RSpec.describe HTMLReport do
  describe '#output_start' do
    it '' do
      expect(described_class.new.output_start).to eq '<html>'
    end
  end

  describe '#output_head' do
    it '' do
      expect(described_class.new.output_head).to match('<head>')
    end

    it '' do
      expect(described_class.new.output_head).to match('</head>')
    end
  end

  describe '#output_end' do
    it '' do
      expect(described_class.new.output_end).to eq '</html>'
    end
  end

  describe '#output_line' do
    it '' do
      expect(described_class.new.output_line('foo')).to eq '    <p>foo</p>'
    end
  end

  describe '#output_body_start' do
    it '' do
      expect(described_class.new.output_body_start).to eq '<body>'
    end
  end

  describe '#output_body_end' do
    it '' do
      expect(described_class.new.output_body_end).to eq '</body>'
    end
  end
end

RSpec.describe Report do
  it "raises NoMethodError for output_line" do
    expect {
      described_class.new.output_line('foo')
    }.to raise_error("You must override output_line in subclass")
  end

  ['output_start', 'output_head', 'output_body_start',
  'output_body_end', 'output_end'].each do |method|
    it "raises NoMethodError for #{method}" do
      expect {
        described_class.new.send method
      }.to raise_error("You must override #{method} in subclass")
    end
  end
end

puts HTMLReport.new.output_report
puts PlainTextReport.new.output_report
