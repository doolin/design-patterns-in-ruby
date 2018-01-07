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
      expect(All.new.evaluate('./files').count).to eq 5
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

    it 'handles regex *.txt' do
      count = Filename.new('*.txt').evaluate('./files').count
      expect(count).to eq 4
    end
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
    it 'finds non-empty files' do
      count = Bigger.new(0).evaluate('./files').count
      expect(count).to eq 1
    end
  end
end

class Writable < Expression
  def evaluate(dir)
    results = []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p if File.writable?(p)
    end
    results
  end
end

RSpec.describe Writable do
  describe '#evaluate' do
    it 'finds writable files' do
      count = Writable.new.evaluate('./files').count
      expect(count).to eq 4
    end
  end
end

class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end

RSpec.describe Not do
  describe '#evaluate' do
    it 'finds the non-writable files' do
      count = Not.new(Writable.new).evaluate('./files').count
      expect(count).to eq 1
    end
  end
end

class Or < Expression
  def initialize(exp1, exp2)
    @exp1 = exp1
    @exp2 = exp2
  end

  def evaluate(dir)
    result1 = @exp1.evaluate(dir)
    result2 = @exp2.evaluate(dir)
    (result1 + result2).sort.uniq
  end
end

RSpec.describe Or do
  describe '#evaluate' do
    it 'finds txt and writable files' do
      count = Or.new(Writable.new, Bigger.new(0)).evaluate('./files').count
      expect(count).to eq 4
    end
  end
end

class And < Expression
  def initialize(exp1, exp2)
    @exp1 = exp1
    @exp2 = exp2
  end

  def evaluate(dir)
    result1 = @exp1.evaluate(dir)
    result2 = @exp2.evaluate(dir)
    (result1 & result2)
  end
end

RSpec.describe And do
  describe '#evaluate' do
    it 'finds big non-writable files' do
      count = And.new(Writable.new, Bigger.new(0)).evaluate('./files').count
      expect(count).to eq 1
    end
  end
end

# TODO: write a test for the scanner.
class Parser
  attr_reader :tokens # for testing

  def initialize(text)
    @tokens = text.scan(/\(|\)|[\w\.\*]+/)
  end

  def next_token
    @tokens.shift
  end

  def expression
    token = next_token

    if token.nil?
      return nil
    elsif token == '('
      result = expression
      raise "Expected ')'" unless next_token == ')'
      result
    elsif token == 'all'
      return All.new
    elsif token == 'writable'
      return Writable.new
    elsif token == 'bigger'
      return Bigger.new(next_token.to_i)
    elsif token == 'filename'
      Filename.new(next_token)
    elsif token == 'not'
      return Not.new(expression)
    elsif token == 'and'
      return And.new(expression, expression)
    elsif token == 'or'
      return Or.new(expression, expression)
    else
      raise "Unexpected token: #{token}"
    end
  end
end

# p. 274
parser = Parser.new("and (and(bigger 1024)(filename *.txt)) writable")
ast = parser.expression

RSpec.describe Parser do
  describe '.new' do
    it 'tokenizes on instantiation' do
      parser = Parser.new("and (and(bigger 1024)(filename *.txt)) writable")
      ast = parser.expression
      expect(ast).not_to be nil
    end
  end

  describe '#expression' do
    it 'all finds all the files' do
      expr = 'all'
      count = Parser.new(expr).expression.evaluate('./files').count
      expect(count).to eq 5
    end

    it 'filename finds files' do
      expr = 'filename *.txt'
      count = Parser.new(expr).expression.evaluate('./files').count
      expect(count).to eq 4
    end

    it 'finds a bigger file' do
      expr = 'bigger(0)'
      ast = Parser.new(expr).expression
      result = ast.evaluate('./files').count
      expect(result).to eq 1
    end
  end
end

class Expression
  def self.|(other)
      Or.new(self, other)
  end

  def self.&(other)
      And.new(self, other)
  end
end

# TODO: figure out what the author is trying to do here,
# then make it work.
=begin
Or.new(
  And.new(Bigger.new(2000), Not.new(Writable.new)), Filename.new('*.txt')
)

Or.new(
  (Bigger.new(2000) & Not.new(Writable.new)) | Filename.new('*.txt')
)
=end

# TODO: figure out whether these belong in the Expression class
# or are top level methods. Might want to check the errata.
# class Expression
  def all
    All.new
  end

  def bigger(size)
    Bigger.new(size)
  end

  def name(pattern)
    Filename.new(pattern)
  end

  def except(expression)
    Not.new(expression)
  end

  def writable
    Writable.new
  end
# end

# TODO: write a spec to evaluate:
exp = Parser.new("(bigger(2000) & except(writable)) | name('*.txt')")


# p. 279
#
# Runt gem
#
# From this paper: https://martinfowler.com/apsupp/recurring.pdf

require 'date'
# TODO: rename this to ruby_temporal.
# NOTE: this crashes unless date/format is removed from the
# gem `lib/runt.rb`
require 'runt'

# TODO: move to let() {}
mondays = Runt::DIWeek.new(Runt::Monday)
wednesdays = Runt::DIWeek.new(Runt::Wednesday)
fridays = Runt::DIWeek.new(Runt::Friday)

RSpec.describe self do
  example 'christmas on Monday in 2015?' do
    expect(mondays.include?(Date.new(2015, 12, 25))).to be false
  end

  example 'christmas on Wednesday in 2015?' do
    expect(wednesdays.include?(Date.new(2015, 12, 25))).to be false
  end

  example 'christmas on Friday in 2015?' do
    expect(fridays.include?(Date.new(2015, 12, 25))).to be true
  end
end

nine_to_twelve = Runt::REDay.new(9, 0, 12, 0)
class_times = (mondays | wednesdays | fridays) & nine_to_twelve

# TODO: wrap a spec around this.
puts class_times
# every every Monday or Wednesday or Friday and from 09:00AM to 12:00PM daily
