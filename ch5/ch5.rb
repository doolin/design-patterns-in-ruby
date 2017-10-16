#!/usr/bin/env ruby

require 'rspec/autorun'
require 'pry'

# Page 96: Observer pattern start of chapter.


# p. 102
module Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers(_self) # api compatibility
    @observers.each do |observer|
      # observer.call(self)
      observer.update(self)
    end
  end

  def changed # for api compatibility with Observable
  end
end

class Employee
  include Subject
  # require 'observer'
  # include Observable

  attr_reader :name
  attr_accessor :title, :salary

  def initialize(name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self)
  end

end

class Payroll
  def update(changed_employee)
    puts "name: #{changed_employee.name}"
    puts "salary: #{changed_employee.salary}"
  end
end

class TaxMan
  def update(changed_employee)
    "Send #{changed_employee.name} tax bill"
  end
end

RSpec.describe Employee do
  describe 'new' do
    it 'instantiates' do
      expect(Employee.new('foo', 'bar', 'baz')).not_to be nil
    end
  end

  context 'give Fred a raise' do
    let(:fred) { Employee.new('Fred', 'Crane Operator', 30_000.0) }

    describe '#salary' do
      example 'fred starts with 30k' do
        expect(fred.salary).to eq 30_000.0
      end

      example 'fred gets a raise' do
        payroll = Payroll.new
        fred.add_observer(payroll)
        expect(payroll).to receive(:update).with(fred)
        fred.salary = 35_000.0
      end

      example 'fred gets a tax bill' do
        payroll = Payroll.new
        taxbill = TaxMan.new
        fred.add_observer(payroll)
        fred.add_observer(taxbill)
        expect(payroll).to receive(:update).with(fred)
        expect(taxbill).to receive(:update).with(fred)
        fred.salary = 90_000.0
      end
    end

    describe '#notify_observers' do
      context 'pass a block' do
        xit 'receives a block' do
          payroll = Payroll.new
          fred.add_observer do |employee|
            payroll.update(employee)
          end
          expect(payroll).to receive(:update).with(fred)
          fred.salary = 35_000.0
        end
      end
    end
  end
end
