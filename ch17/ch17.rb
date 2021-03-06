#!/usr/bin/env ruby

require 'rspec/autorun'

def plant(stem_type, leaf_type)
  plant = Object.new

  if stem_type == :fleshy
    def plant.stem
      'fleshy'
    end
  else
    def plant.stem
      'woody'
    end
  end

  if leaf_type == :broad
    def plant.leaf
      'broad'
    end
  else
    def plant.leaf
      'needle'
    end
  end

  plant
end

RSpec.describe self do
  describe '#plant' do
    it 'defines "#stem"' do
      expect(plant(:woody, :broad).stem).to eq 'woody'
      expect(plant(:woody, :broad).leaf).to eq 'broad'
    end
  end
end

module Carnivore
  def diet
    'meat'
  end

  def teeth
    'sharp'
  end
end

module Herbivore
  def diet
    'plant'
  end

  def teeth
    'flat'
  end
end

module Nocturnal
  def sleep_time
    'day'
  end

  def awake_time
    'night'
  end
end

module Diurnal
  def sleep_time
    'night'
  end

  def awake_time
    'day'
  end
end

def new_animal(diet, awake)
  animal = Object.new

  if diet == :meat
    animal.extend(Carnivore)
  else
    animal.extend(Herbivore)
  end

  if awake == :day
    animal.extend(Diurnal)
  else
    animal.extend(Nocturnal)
  end

  animal
end

class CompositeBase
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.member_of(composite_name)
    code = %Q(attr_accessor :parent_#{composite_name})
    class_eval(code)
  end

  def self.composite_of(composite_name)
    code = %Q(
      def sub_#{composite_name}s
        @sub_#{composite_name}s = [] unless @sub_#{composite_name}s
        @sub_#{composite_name}s
      end

      def add_sub_#{composite_name}(child)
        return if sub_#{composite_name}s.include?(child)
        sub_#{composite_name}s << child
        child.parent_#{composite_name} = self
      end

      def delete_sub_#{composite_name}(child)
        return unless sub_#{composite_name}s.include?(child)
        sub_#{composite_name}s.delete(child)
        child.parent_#{composite_name} = nil
      end
    )
    class_eval(code)
  end
end

class Tiger < CompositeBase
  member_of(:population)
  member_of(:classification)
end

class Jungle < CompositeBase
  composite_of(:population)
end

RSpec.describe Jungle do
  let(:tony_tiger) { Tiger.new('tony') }

  it 'parent_population' do
    se_jungle = Jungle.new('southeastern jungle tigers')
    se_jungle.add_sub_population(tony_tiger)
    expect(tony_tiger.parent_population).to eq se_jungle
  end

  it 'parent_classification' do
    species = Species.new('P. tigris')
    species.add_sub_classification(tony_tiger)
    expect(tony_tiger.parent_classification).to eq species
  end
end

class Species < CompositeBase
  composite_of(:classification)
end

