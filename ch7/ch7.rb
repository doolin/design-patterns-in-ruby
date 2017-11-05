#!/usr/bin/env ruby

require 'rspec/autorun'

# The iterator pattern allows processing objects
# sequentially without exposing its internals.
#
# This is going to be a tough chapter for me as the
# material feels a bit more dated than what I've worked
# through so far, and the examples feel contrived. This
# may be precisely the right reason to work through the
# material in a lot more detail, so I'll just go ahead
# and get started into it.
#
# Also worth remembering part of why I'm working through
# the material is to baseline myself.

# External iterator
class ArrayIterator
  def initialize(array)
    @array = array
    @index = 0
  end

  def has_next?
    @index < @array.length
  end

  def item
    @array[@index]
  end

  def next_item
    value = item # @array[@index]
    @index += 1
    value
  end
end

# Internal iterator
def for_each_element(array)
  i = 0
  while i < array.length
    yield(array[i])
    i += 1
  end
end

RSpec.describe ArrayIterator do
  describe '#has_next' do
    it 'iterates' do
      array = ['red', 'green', 'blue']
      iter = described_class.new(array)
      expect(iter.next_item).to eq 'red'
      expect(iter.next_item).to eq 'green'
      expect(iter.next_item).to eq 'blue'
      expect(iter.next_item).to be nil
    end
  end
end

# Some discussion about internal and external iterators follows.
# Ruby has external iterators available as calls to `each` without
# a block return the iterator itself.

def merge(array1, array2)
  merged = []

  iterator1 = ArrayIterator.new(array1)
  iterator2 = ArrayIterator.new(array2)

  while iterator1.has_next? && iterator2.has_next?
    if iterator1.item < iterator2.item
      merged << iterator1.next_item
    else
      merged << iterator2.next_item
    end
  end

  while iterator1.has_next?
    merged << iterator1.next_item
  end

  while iterator2.has_next?
    merged << iterator2.next_item
  end

  merged
end

RSpec.describe 'merge array' do
  it 'merges sorted arrays' do
    a1 = [1, 3, 5, 7, 9]
    a2 = [2, 4, 6, 8, 10]
    expect(merge(a1, a2)).to eq((1..10).to_a)
  end
end

# p. 133, a bit of Ruby review, stuff I have done
# in the past but isn't at the top of head always.
# It's good to write a bit of code this way once
# in a while.
RSpec.describe Enumerable do
  describe '#all?' do
    it 'finds an execption' do
      expect(['joe', 'sam', 'george'].all? { |e| e.length < 4 }).to be false
    end
  end

  describe '#any?' do
    it 'finds an execption' do
      expect(['joe', 'sam', 'george'].any? { |e| e.length < 4 }).to be true
    end
  end
end

class Account
  attr_accessor :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def <=>(other)
    balance <=> other.balance
  end
end

class Portfolio
  include Enumerable

  def initialize
    @accounts = []
  end

  def each(&block)
    @accounts.each(&block)
  end

  def add_account(account)
    @accounts << account
  end
end

RSpec.describe Account do
  describe '#<=>' do
    it 'compares correctly' do
      a1 = Account.new('foo', 1)
      a2 = Account.new('bar', 2)
      a3 = Account.new('baz', 1)

      aggregate_failures do
        expect(a1 <=> a2).to eq(-1)
        expect(a2 <=> a1).to eq(1)
        expect(a3 <=> a1).to eq(0)
      end
    end
  end
end

RSpec.describe Portfolio do
  let!(:portfolio) { Portfolio.new }

  before do
    portfolio.add_account(Account.new('foo', 10))
    portfolio.add_account(Account.new('bar', 100))
  end

  describe '#any?' do
    it 'does not find large value account' do
      expect(portfolio.any? { |a| a.balance > 1000 }).to be false
    end

    it 'finds small accounts' do
      expect(portfolio.any? { |a| a.balance < 1000 }).to be true
    end
  end

  describe '#all?' do
    it 'asserts all accounts larger than 0 balance' do
      expect(portfolio.all? { |a| a.balance > 0 }).to be true
    end

    it 'finds small value account' do
      expect(portfolio.all? { |a| a.balance < 1000 }).to be true
    end

    it 'has accounts greater than 100' do
      expect(portfolio.all? { |a| a.balance < 100 }).to be false
    end
  end
end
