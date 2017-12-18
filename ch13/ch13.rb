#!/usr/bin/env ruby

require 'rspec/autorun'
require 'pry'

class Duck
  def initialize(name)
    @name = name
  end

  def eat
    "Duck #{@name} is eating"
  end

  def speak
    "Duck #{@name} is speaking"
  end

  def sleep
    "Duck #{@name} sleeps quietly"
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

class FirstPond
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

class DuckPond < FirstPond
  def new_animal(name)
    Duck.new(name)
  end
end

class FrogPond < FirstPond
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

class WaterLily
  def initialize(name)
    @name = name
  end

  def grow
    "WaterLily #{@name} grows"
  end
end

class Pond
  def initialize(number_animals, number_plants)
    @nanimal = []
    number_animals.times do |index|
      animal = new_animal("Animal#{index}")
      @animals < animal
    end

    @plants = []
    number_plants.times do |index|
      plant = new_plant("Plant#{index}")
      @plants < plant
    end
  end

  def simulate_one_day
    @plants.each { |plant| plant.grow }
    @animals.each { |animal| animal.speak }
    @animals.each { |animal| animal.eat }
    @animals.each { |animal| animal.sleep }
  end
end

class DuckWateeLilyPond < Pond
  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
    WaterLily.new(name)
  end
end

class FrogAlgaePond < Pond
  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
    Algae.new(name)
  end
end

# Things get contrived past here.

# Let's try reopening Pond...
class Pond
  def initialize(number_animals, number_plants)
    @nanimal = []
    number_animals.times do |index|
      animal = new_organism(:animal, "Animal#{index}")
      @animals < animal
    end

    @plants = []
    number_plants.times do |index|
      plant = new_organism(:plant, "Plant#{index}")
      @plants < plant
    end
  end
end

class DuckWaterLilyPond < Pond
  def new_organism(type, name)
    if type == :animal
      Duck.new(name)
    elsif type == :plant
      WaterLily.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end

class Pond
  def initialize(number_animals, animal_class,
                 number_plants, plant_class)
    @animal_class = animal_class
    @plant_class = plant_class

    @animals = []
    number_animals.times do |index|
      animal = new_organism(:animal, "Animal#{index}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |index|
      plant = new_organism(:plant, "Plant#{index}")
      @plants << plant
    end
  end

  def new_organism(type, name)
    if type == :animal
      @animal_class.new(name)
    elsif type == :plant
      @plant_class.new(name)
    else
      raise "Unknown organism type: #{type}"
    end
  end
end

pond = Pond.new(3, Duck, 2, WaterLily)
pond.simulate_one_day
