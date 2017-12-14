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

# So far, not a fan of this method for Ruby code. It feels
# overly complex and strangely restrictive at the same time.
# One would think the complexity would be accompanied by
# flexibility. Perhaps I'm not seeing it. I plan on working
# throug the rest of the chapter, but probably not adding
# a lot of testing, as it seems pointless. I should probably
# add to these remarks that while this book is going pretty
# slow (as demonstrated by the commits), I'm also working
# on at least one other project in a private repo.

class Algae
  def initialize(name)
    @name = name
  end

  def grow
    "Algae #{@name} grows"
  end
end
