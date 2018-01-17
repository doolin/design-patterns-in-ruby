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

  # TODO: leaf type

  plant
end

RSpec.describe self do
  describe '#plant' do
    it 'defines "#stem"' do
      expect(plant(:woody, :broad).stem).to eq 'woody'
    end
  end
end
