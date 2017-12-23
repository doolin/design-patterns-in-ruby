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
    "Frog #{@name} is eating"
  end

  def speak
    "Frog #{@name} croaks"
  end

  def sleep
    "Frog #{@name} doesn't sleep"
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

class Tree
  def initialize(name)
    @name = name
  end

  def grow
    "#{@name} grows tall"
  end
end

class Tiger
  def initialize(name)
    @name = name
  end

  def eat
    "Tiger #{@name} eats what it wants"
  end

  def speak
    "Tiger #{@name} raors"
  end

  def sleep
    "Tiger #{@name} sleeps where it wants"
  end
end

class Habitat < Pond
end

jungle = Habitat.new(1, Tiger, 4, Tree)
jungle.simulate_one_day

pond = Pond.new(3, Duck, 2, WaterLily)
pond.simulate_one_day

class PondOrganismFactory
  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
    Algae.new(name)
  end
end

class JungleOrganismFactory
  def new_animal(name)
    Tiger.new(name)
  end

  def new_plant(name)
    Tree.new(name)
  end
end

class Habitat
  def initialize(number_animals, number_plants, organism_factory)
    @organism_factory = organism_factory

    @animals = []
    number_animals.times do |i|
      animal = @organism_factory.new_animal("Animal#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = @organism_factory.new_plant("Plant#{i}")
      @plants << plant
    end
  end
end

jungle = Habitat.new(1, 4, JungleOrganismFactory.new)
jungle.simulate_one_day

pond = Habitat.new(2, 4, PondOrganismFactory.new)
pond.simulate_one_day

class OrganismFactory
  def initialize(plant_class, animal_class)
    @plant_class = plant_class
    @animal_class = animal_class
  end

  def new_animal(name)
    @animal_class.new(name)
  end

  def new_plant(name)
    @plant_class.new(name)
  end
end

jungle_organism_factory = OrganismFactory.new(Tree, Tiger)
pond_organism_factory = OrganismFactory.new(WaterLily, Frog)

jungle = Habitat.new(1, 4, jungle_organism_factory)
jungle.simulate_one_day

pond = Habitat.new(2, 4, pond_organism_factory)
pond.simulate_one_day

class IOFactory
  def initialize(format)
    @reader_class = self.class.const_get("#{format}Reader")
    @writer_class = self.class.const_get("#{format}Writer")
  end

  def new_reader
    @reader_class.new
  end

  def new_writer
    @writer_class.new
  end
end

class HTMLReader; end
class HTMLWriter; end
class PDFReader; end
class PDFWriter; end

html_factory = IOFactory.new('HTML')
html_reader = html_factory.new_reader

pdf_factory = IOFactory.new('PDF')
pdf_writer = pdf_factory.new_writer

RSpec.describe IOFactory do
  describe '.new' do
    context 'HTMLReader' do
      it '' do
        expect(IOFactory.new('HTML').new_reader.class).to eq HTMLReader
      end
    end
  end
end
