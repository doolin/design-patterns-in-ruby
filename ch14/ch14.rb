#!/usr/bin/env ruby

require 'rspec/autorun'
require 'pry'

class Computer
  attr_accessor :display
  attr_accessor :motherboard
  attr_accessor :drives

  def initialize(display = :crt, motherboard = Motherboard.new, drives = [])
    @display = display
    @motherbaord = motherboard
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
