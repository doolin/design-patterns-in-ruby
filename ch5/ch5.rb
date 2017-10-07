#!/usr/bin/env ruby

require 'rspec/autorun'

# Page 96: Observer pattern.

class Employee
  attr_reader :name
  attr_accessor :title, :salary

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end
end

RSpec.describe Employee do
  describe 'new' do
    it 'instantiates' do
      expect(Employee.new('foo', 'bar', 'baz')).not_to be nil
    end
  end
end
