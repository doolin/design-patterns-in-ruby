#!/usr/bin/env ruby

require 'rspec/autorun'

# The Template method

class Report
  def initialize
    @title = 'monthly report'
    @test = [ 'Things are going', 'really, really well']
  end

  # I would have named this simply 'output', or possibly
  # 'write'.
  def output_report
    puts('<html>')
    puts('  <head>')
    puts("    <title>#{title}</title>")
    puts('  </head>')
    puts('  <body>')
    @text.each { |line| puts("      <p>#{line}</p>") }
    puts('  </body>')
    puts('</html>')
  end
end

RSpec.describe Report do
  describe '.new' do
    it 'instantiates' do
      expect(Report.new).not_to be nil
    end
  end
end
