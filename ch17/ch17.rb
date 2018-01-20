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


