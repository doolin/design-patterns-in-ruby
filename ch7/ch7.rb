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

RSpec.describe ArrayIterator do
  describe '.new' do
    xit 'instantiates' do
      array = [1, 2, 3]
    end
  end
end
