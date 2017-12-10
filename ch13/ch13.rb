#!/usr/bin/env ruby

require 'rspec/autorun'

class Duck
  def initialize(name)
    @name = name
  end

  def eat
    "Duck #{name} is eating"
  end

  def speak
    "Duck #{name} is speaking"
  end

  def sleep
    "Duck #{name} sleeps quietly"
  end
end


