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

class Frog
  def initialize(name)
    @name = name
  end

  def eat
    "Frog #{name} is eating"
  end

  def speak
    "Frog #{name} croaks"
  end

  def sleep
    "Frog #{name} doesn't sleep"
  end
end

class Pond
  def initialize(number_animals)
    @animals = []
    number_animals.times do |i|
      animal = animal.new("animals #{i}")
      @animals << animal
    end
  end

  def simulate_one_day
    @animal.each { |animal| animal.speak }
    @animal.each { |animal| animal.eat }
    @animal.each { |animal| animal.sleep }
  end
end

class DuckPond < Pond
  def new_animal(name)
    Duck.new(name)
  end
end

class FrogPond < Pond
  def new_animal(name)
    Frog.new(name)
  end
end
