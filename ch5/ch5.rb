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
    @observers = []
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
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
      expect(Employee.new('foo', 'bar', 'baz')).not_to be nil
    end
  end
end
