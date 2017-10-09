#!/usr/bin/env ruby

require 'rspec/autorun'

# Page 96: Observer pattern.

class Employee
  attr_reader :name
  attr_accessor :title, :salary

  def initialize(name, title, salary, payroll)
    @name = name
    @title = title
    @salary = salary
    @payroll = payroll
  end

  def salary=(new_salary)
    @salary = new_salary
    @payroll.update(self)
  end
end

class Payroll
  def update(changed_employee)
    puts "name: #{changed_employee.name}"
    puts "salary: #{changed_employee.salary}"
  end
end

RSpec.describe Employee do
  describe 'new' do
    it 'instantiates' do
      expect(Employee.new('foo', 'bar', 'baz', Payroll.new)).not_to be nil
    end
  end
end
