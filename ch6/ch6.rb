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

class MakeBatterTask < Task
  def initialize
    super('make batter')
    @sub_tasks = []
    add_sub_task(AddDryIngredientsTask.new)
    # add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end

  def add_sub_task(task)
    @sub_tasks << task
  end

  def delete_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required
    @sub_tasks.sum(&:get_time_required)
  end
end

RSpec.describe MakeBatterTask do
  describe 'get_time_required' do
    it 'sums batter making tasks' do
      expect(MakeBatterTask.new.get_time_required).to eq 4.0
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
