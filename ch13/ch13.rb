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

class Pond
  def initialize(number_ducks)
    @ducks = []
    number_ducks.times do |i|
      duck = Duck.new("Ducks #{i}")
      @ducks << duck
    end
  end

  def simulate_one_day
    @duck.each { |duck| duck.speak }
    @duck.each { |duck| duck.eat }
    @duck.each { |duck| duck.sleep }
  end
end
