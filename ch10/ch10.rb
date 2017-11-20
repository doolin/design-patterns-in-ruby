#!/usr/bin/env ruby

require 'rspec/autorun'

# Chapter 10, the proxy pattern.

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
  subject(:account) { BankAccount.new(100) }

  describe '#deposit' do
    it '10 dollars' do
      account.deposit(10)
      expect(account.balance).to eq 110
    end
  end

  describe '#withdraw' do
    example '10 dollars' do
      account.withdraw(10)
      expect(account.balance).to eq 90
    end
  end
end

class BankAccountProxy
  def initialize(real_object)
    @real_object = real_object
  end

  def balance
    @real_object.balance
  end

  def deposit(amount)
    @real_object.deposit(amount)
  end

  def withdraw(amount)
    @real_object.withdraw(amount)
  end
end

RSpec.describe BankAccountProxy do
  let(:real_account) { BankAccount.new(100) }

  subject(:proxy) { BankAccountProxy.new(real_account) }

  describe '#deposit' do
    it '10 dollars' do
      proxy.deposit(10)
      expect(proxy.balance).to eq 110
    end
  end

  describe '#withdraw' do
    example '10 dollars' do
      proxy.withdraw(10)
      expect(proxy.balance).to eq 90
    end
  end
end

require 'etc'
class AccountProtectionProxy
  def initialize(real_account, owner_name)
    @real_account = real_account
    @owner_name = owner_name
  end

  def balance
    check_access
    @real_account.balance
  end

  def deposit(amount)
    check_access
    @real_account.deposit(amount)
  end

  def withdraw(amount)
    check_access
    @real_account.withdraw(amount)
  end

  def check_access
    if Etc.getlogin != @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access account"
    end
  end
end

RSpec.describe AccountProtectionProxy do
  let(:real_account) { BankAccount.new(100) }

  context 'with correct owner' do
    subject(:proxy) { AccountProtectionProxy.new(real_account, 'doolin') }

    describe '#deposit' do
      it '10 dollars' do
        proxy.deposit(10)
        expect(proxy.balance).to eq 110
      end
    end

    describe '#withdraw' do
      example '10 dollars' do
        proxy.withdraw(10)
        expect(proxy.balance).to eq 90
      end
    end
  end

  context 'with wrong owner' do
    let!(:wrong_owner) { 'doolin' }
    subject(:proxy) { AccountProtectionProxy.new(real_account, 'foobar') }

    describe '#deposit' do
      it '10 dollars' do
        expect {
          proxy.deposit(10)
        }.to raise_error(RuntimeError, /#{wrong_owner}/)
        expect(real_account.balance).to eq 100
      end
    end

    describe '#withdraw' do
      example '10 dollars' do
        expect {
          proxy.withdraw(10)
        }.to raise_error(RuntimeError, /#{wrong_owner}/)
        expect(real_account.balance).to eq 100
      end
    end
  end
end

# Virtual proxy, p. 181
class VirtualAccountProxy
  def initialize(starting_balance)
    @starting_balance = starting_balance
  end

  def deposit(amount)
    subject.deposit(amount)
  end

  def withdraw(amount)
    subject.withdraw(amount)
  end

  def balance
    subject.balance
  end

  def subject
    @subject ||= BankAccount.new(@starting_balance)
  end
end

RSpec.describe VirtualAccountProxy do
end
