#!/usr/bin/env ruby

require 'rspec/autorun'

class Task
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_time_required
    0.0
  end
end

class AddDryIngredientsTask < Task
  def initialize
    super('add dry ingredients')
  end

  def get_time_required
    1.0
  end
end

class MixTask < Task
  def initialize
    super('mix ingredients')
  end

  def get_time_required
    3.0
  end
end

RSpec.describe Task do
  describe '.new' do
    it 'instantiates' do
      name = 'foo'
      expect(Task.new(name)).to_not be nil
    end
  end
end
