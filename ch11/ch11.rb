#!/usr/bin/env ruby

require 'rspec/autorun'

# Decorators

# An example class, won't be using this one.
class SimpleWriter
  def initialize(path)
    @file = File.open(path, 'w')
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def pos
    @file.pos
  end

  def rewind
    @file.rewind
  end

  def close
    @file.close
  end
end

class WriterDecorator
  def initialize(real_writer)
    @real_writer = real_writer
  end

  def write_line(line)
    @real_writer.write_line(line)
  end

  def pos
    @real_writer.pos
  end

  def rewind
    @real_writer.rewind
  end

  def close
    @real_writer.close
  end
end

class NumberingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  def write_line(line)
    @real_writer.write_line("#{@line_number}: #{line}")
    @line_number += 1
  end
end

RSpec.describe NumberingWriter do
  def path
    '/tmp/final.txt'
  end

  def text
    'Hello out there'
  end

  describe '#write_line' do
    it '' do
      writer = NumberingWriter.new(SimpleWriter.new(path))
      writer.write_line(text)
      # TODO: find out why closing a file truncates the last character
      # when reading this file back in.
      # writer.close
      File.readlines(path, 'r').each do |line|
        expect(line).to eq "1: #{text}"
      end
    end
  end
end
