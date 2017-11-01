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
