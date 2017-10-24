#!/usr/bin/env ruby

require 'rspec/autorun'

# p. 111 Composite Task
#
# The interesting thing about this chapter and pattern
# is the author builds a tree structure explicitly, noting
# and enforcing different behavior (methods) between the
# leaf nodes ("Task") and internal nodes ("CompositeTasks").
#
# Is this is a good idea? Why not use a tree container for
# instead? The Tree container can also be used to demonstrate
# composition.

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

class AddLiquidsTask
  def get_time_required
    0.0
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

class CompositeTask < Task
  attr_accessor :sub_tasks

  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def add_sub_task(task)
    @sub_tasks << task
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def <<(task)
    @sub_tasks << task
  end

  def [](index)
    @sub_tasks[index]
  end

  def get_time_required
    @sub_tasks.sum(&:get_time_required)
  end
end

class MakeBatterTask < CompositeTask
  def initialize
    super('make batter')
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end
end

RSpec.describe MakeBatterTask do
  context 'adding tasks with explicit method' do
    describe 'get_time_required' do
      it 'sums batter making tasks' do
        expect(MakeBatterTask.new.get_time_required).to eq 4.0
      end
    end
  end

  describe '[]' do
    it 'accesses' do
      expect(MakeBatterTask.new[0].class).to eq AddDryIngredientsTask
    end
  end
end

require 'pry'

RSpec.describe CompositeTask do
  context 'adding tasks with shovel' do
    describe '<<' do
      it 'sums batter making tasks' do
        task = CompositeTask.new('make batter')
        task << AddDryIngredientsTask.new
        task << AddLiquidsTask.new
        task << MixTask.new
        expect(task.get_time_required).to eq 4.0
      end
    end
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
