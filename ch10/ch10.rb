#!/usr/bin/env ruby

require 'rspec/autorun'

class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end

RSpec.describe BankAccount do
  describe '#deposit' do
  end

  describe '#withdraw' do
  end
end
