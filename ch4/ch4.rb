#!/usr/bin/env ruby

require 'rspec/autorun'

# Page 77: Strategy pattern. A collection of objects which
# do the same job in different ways, all using the same
# interface. The authors provide an example of tax calculation
# differing by states.
#
# Strategy pattern is implemented using delegation and composition
# rather than inheritance.

class Formatter
  def output_report(title, text)
    raise "You must override #{__method__}"
  end
end

class HTMLFormatter < Formatter
  def output_report(title, text)
    report = ''
    report << '<html>'
    report << '  <head>'
    report << "    <title>#{title}</title>"
    report << '  </head>'
    report << '  <body>'
    text.each do |line|
      report << "      <p>#{line}</p>"
    end
    report << '  </body>'
    report << '</html>'
    report
  end
end

class PlainTextFormatter < Formatter
  def output_report(title, text)
    report = ''
    report << "**** #{title} ****"
    text.each { |line| report << line }
    report
  end
end

class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = 'Monthly Report'
    @text = ['Things are going well', 'really, really well']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(@title, @text)
  end
end

RSpec.describe Report do
  context 'PlainTextFormatter' do
    example '#output_report' do
      formatter = PlainTextFormatter.new
      actual = Report.new(formatter).output_report
      expect(actual).to match(/\*\*\*\* Monthly/)
      expect(actual).to match(/well/)
    end
  end

  context 'HTMLFormatter' do
    example '#output_report' do
      formatter = HTMLFormatter.new
      actual = Report.new(formatter).output_report
      expect(actual).to match(/<title>Monthly/)
      expect(actual).to match(/well/)
    end
  end
end

RSpec.describe HTMLFormatter do
  describe '#output_report' do
    it '' do
      expect(HTMLFormatter.new.output_report("foo", ["bar"])).to match(/foo/)
    end
  end
end

RSpec.describe PlainTextFormatter do
  describe '#output_report' do
    it '' do
      expect(PlainTextFormatter.new.output_report('baz', ['quux'])).to match(/quux/)
    end
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

### Section on procs and lambdas
#
# This is good for review, procs and lambdas are the
# more arcane areas of Ruby, and worth revisiting on
# a regular basis.

RSpec.describe 'page 85 on procs and lambdas' do
  it '' do
    name = 'john'
    mary = Proc.new do
      name = 'mary'
    end
    expect(name).to eq 'john'
    mary.()
    expect(name).to eq 'mary'
  end
end
