#!/usr/bin/env ruby

require 'rspec/autorun'
require 'pry'

require 'find'

class Expression
end

class All < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end

RSpec.describe All do
  describe '#evaluate' do
    it '' do
      expect(All.new.evaluate('./files').count).to eq 1
    end
  end
end

class Filename < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      name = File.basename(p)
      results << p if File.fnmatch(@pattern, name)
    end
    results
  end
end

RSpec.describe Filename do
  describe '#evaluate' do
    it '' do
      count = Filename.new('foo.txt').evaluate('./files').count
      expect(count).to eq 1
    end

    it 'handles regex *.txt'
  end
end

class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if (File.size(p) > @size)
    end
    results
  end
end

RSpec.describe Bigger do
  describe '#evaluate' do
    it 'finds non-empty files'
  end
end
