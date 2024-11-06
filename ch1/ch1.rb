#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rspec/autorun'

# Building better programs
#
# * Separate things which change from things which don't.
# * Program to interface, not to implementation.
# * Prefer composition over inheritance.
# * Delegate, delegate, delegate.

# In this example from chapter 1, starting and stopping
# engines is delegated to specific engine classes. I've gone
# a little further and moved the start and stop into a
# super class.
class Engine
  def start
    'engine started'
  end

  def stop
    'engine stopped'
  end
end

class GasolineEngine < Engine
end

class DieselEngine < Engine
end

# Make rubocop happy
class Car
  # It would almost surely be better to pass the engine
  # class in as a parameter.
  def initialize
    @engine = GasolineEngine.new
  end

  def sunday_drive
    @engine.start << 'cruising around' << @engine.stop
  end

  # For those vehicles which (apparently) have a choice
  # of engines to start, starting a different engine might
  # be better abstracted out into a class for selecting
  # an engine. Situation dictates. But this doesn't smell
  # right to me.
  def switch_to_diesel
    @emgine = DieselEngine.new
  end

  def start_engine
    @engine.start
  end

  def stop_engine
    @engine.stop
  end
end

RSpec.describe Car do
  describe '.initialize' do
    it 'instantiates' do
      expect(described_class.new.class).to eq described_class
    end
  end

  describe '#sunday_drive' do
    it 'cruises around' do
      expect(described_class.new.sunday_drive).to match(/cruising around/)
    end
  end

  describe '#switch_to_diesel' do
    skip('add an example for diesel')
  end

  describe '#start_engine' do
    it 'starts' do
      expect(described_class.new.start_engine).to eq 'engine started'
    end
  end

  describe '#stop_engine' do
    it 'stops' do
      expect(described_class.new.stop_engine).to eq 'engine stopped'
    end
  end
end

RSpec.describe GasolineEngine do
  describe 'start' do
    it '' do
      expect(described_class.new.start).to eq 'engine started'
    end
  end

  describe 'stop' do
    it '' do
      expect(described_class.new.start).to eq 'engine started'
    end
  end
end

RSpec.describe DieselEngine do
  describe 'start' do
    it '' do
      expect(described_class.new.start).to eq 'engine started'
    end
  end

  describe 'stop' do
    it '' do
      expect(described_class.new.start).to eq 'engine started'
    end
  end
end
