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
