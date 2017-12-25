#!/usr/bin/env ruby

require 'rspec/autorun'
require 'pry'

class Computer
  attr_accessor :display
  attr_accessor :motherboard
  attr_accessor :drives

  def initialize(display = :crt, motherboard = Motherboard.new, drives = [])
    @display = display
    @motherboard = motherboard
    @drives = drives
  end
end

class Cpu; end

class BasicCpu < Cpu
end

class TurboCpu < Cpu
end

class Motherboard
  attr_accessor :cpu
  attr_accessor :memory_size

  def initialize(cpu = BasicCpu.new, memory_size = 1000)
    @cpu = cpu
    @memory_size = memory_size
  end
end

class Drive
  attr_reader :type # :hard_disk, :cd, :dvd
  attr_reader :size # MB
  attr_reader :writable

  def initialize(type, size, writable)
    @type = type
    @size = size
    @writable = writable
  end
end

motherboard  = Motherboard.new(TurboCpu.new, 4000)

drives = []
drives << Drive.new(:hard_drive, 200_000, true)
drives << Drive.new(:cd, 760, true)
drives << Drive.new(:dvd, 4700, false)

computer = Computer.new(:lcd, motherboard, drives)

class ComputerBuilder
  attr_reader :computer

  def initialize
    @computer = Computer.new
  end

  def turbo(has_turbo_cpu = true)
    @computer.motherboard.cpu = TurboCpu.new
  end

  def memory_size(size_in_mb)
    @computer.motherboard.memory_size = size_in_mb
  end
end

# p. 253
builder = ComputerBuilder.new
builder.turbo
# builder.add_cd(true)
# builder.add_dvd
# builder.add_hard_disk(100_000)

computer = builder.computer

class DesktopComputer < Computer
end

class LaptopComputer < Computer
  def initialize(motherboard = Motherboard.new, drives = [])
    super(:lcd, motherboard, drives)
  end
end

class DesktopBuilder < ComputerBuilder
  def display=(display)
    @computer.display = display
  end

  def add_cd(writable = false)
    @computer.drives << Drive.new(:cd, 760, writable)
  end

  def add_dvd(writable = false)
    @computer.drives << Drive.new(:dvd, 4000, writable)
  end

  def add_hard_disk(size_in_mb)
    @computer.drives << Drive.new(:hard_disk, size_in_mb, true)
  end
end

class LaptopDrive < Drive
end

class LaptopBuilder < ComputerBuilder
  def display=(display)
    @computer.display = display
  end

  def add_cd(writable = false)
    @computer.drives << LaptopDrive.new(:cd, 760, writable)
  end

  def add_dvd(writable = false)
    @computer.drives << LaptopDrive.new(:dvd, 4000, writable)
  end

  def add_hard_disk(size_in_mb)
    @computer.drives << LaptopDrive.new(:hard_disk, size_in_mb, true)
  end
end

class Computer
  def computer
    raise 'Not enough memory' if @computer.motherboard.memory_size < 250
    raise 'Too many drives' if @computer.drives.size > 4
    hard_disk = @computer.drives.find { |drive| drive.type == :hard_drive }
    raise 'No hard disk' unless hard_disk
  end
end
