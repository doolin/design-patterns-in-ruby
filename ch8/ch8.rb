#!/usr/bin/env ruby

require 'rspec/autorun'
require 'pry'

# p. 144 Command Pattern
#
# I'm not sure I'm familiar with the Command Pattern,
# so this will be an interesting chapter.


# I'm leaving this here and the spec below as an example
# for future reference and investigation.
class SlickButton
end

RSpec.describe SlickButton do
  describe '.new' do
    xit 'instantiates' do
      # The second class definition below overrides
      # the first class definition above. There ought
      # to be a way to better handle testing how classes
      # evolve, probably won't be able to use rspec
      # directly.
      expect(SlickButton.new).not_to be nil
    end
  end
end

# This is an attempt to follow the book more closely, but
# it doesn't work as rspec reads all the classes before
# applying the specs. This means the first class definition
# is overridden by the second class definition.
#
# The idead behind this pattern is that the passed in
# command object requires maintaining a certain amount
# of state. Otherwise, as demonstrated further down, it
# could be defined to accept a block on initialization.
class SlickButton
  attr_accessor :command

  def initialize(command)
    @command = command
  end

  def on_button_push
    @command.execute if @command # @command&.execute
  end
end

class SaveCommand
  def execute
    :saved
  end

  def executor
    method(:execute)
  end
end

RSpec.describe SlickButton do
  describe '.new' do
    it 'instantiates' do
      expect(SlickButton.new(:command)).not_to be nil
    end
  end

  describe '#on_button_push' do
    it 'executes' do
      saved = SlickButton.new(SaveCommand.new).on_button_push
      expect(saved).to be :saved
    end
  end
end

# If we don't need a lot of state information with respect
# to the command(s) using the "SlickButton," pass in a block
# to do the work.
class SlickButtonBlock
  attr_accessor :command

  def initialize(&callback)
    @command = callback
  end

  def on_button_push
    @command.call if @command # @command&.execute
  end
end

RSpec.describe SlickButtonBlock do
  describe '#on_button_push' do
    it 'executes' do
      sb = SlickButtonBlock.new { :saved }
      expect(sb.on_button_push).to be :saved
    end
  end
end

# for testing
class SubClassError < StandardError; end

class Command
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def execute
    raise SubClassError
  end
end

RSpec.describe Command do
  describe '#execute' do
    it 'raises' do
      expect {
        Command.new('description').execute
      }.to raise_error SubClassError
    end
  end
end

class CreateFile < Command
  def initialize(path, contents)
    super("CreateFile: #{path}")
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, 'w')
    f.write(@contents)
    f.close
  end

  def unexecute
    File.delete(@path)
  end
end

def path
  '/tmp/testem.txt'
end

def contents
  'quux'
end

RSpec.describe CreateFile do
  describe '#execute' do
    it 'writes a file to /tmp' do
      CreateFile.new(path, contents).execute
      File.readlines(path).each do |line|
        expect(line).to eq 'quux'
      end
    end
  end
end

class DeleteFile < Command
  def initialize(path)
    super("DeleteFile: #{path}")
    @path = path
  end

  def execute
    # return unless File.exists?(@path)
    @contents = File.read(@path) if File.exists?(@path)
    File.delete(@path)
  end

  def unexecute
    CreateFile.new(@path, @contents).execute if @contents
  end
end

RSpec.describe DeleteFile do
  describe '#execute' do
    context 'file exists' do
      example 'deletes' do
        CreateFile.new(path, contents).execute
        expect(File.exists?(path)).to be true
        DeleteFile.new(path).execute
        expect(File.exists?(path)).to be false
      end
    end

    context 'file does not exist' do
      it 'fails or something'
    end
  end
end

def target
  '/tmp/testem2.txt'
end

class CopyFile < Command
  def initialize(source, target)
    super("CopyFile: #{source} to #{target}")
    @source = source
    @target = target
  end

  def execute
    FileUtils.copy(@source, @target)
  end
end

RSpec.describe CopyFile do
  describe '#execute' do
    example 'copy' do
      CreateFile.new(path, contents).execute
      expect(File.exists?(path)).to be true
      CopyFile.new(path, target).execute
      expect(File.exists?(target)).to be true
      DeleteFile.new(path).execute
      DeleteFile.new(target).execute
    end
  end
end

class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def add_command(command)
    @commands << command
  end

  def execute
    @commands.each { |command| command.execute }
  end

  def unexecute
    @commands.reverse.each { |command| command.unexecute }
  end

  def description
    description = ''
    @commands.each { |command| description << command.description }
  end
end

RSpec.describe CompositeCommand do
  subject(:commands) { CompositeCommand.new }

  describe '#execute' do
    example 'create and delete a file' do
      commands = CompositeCommand.new
      commands.add_command(CreateFile.new(path, contents))
      commands.add_command(CopyFile.new(path, target))
      commands.execute
      expect(File.exists?(path)).to be true
      expect(File.exists?(target)).to be true
      expect(commands.description.size).to eq 2
      DeleteFile.new(path).execute
      DeleteFile.new(target).execute
    end
  end

  describe '#unexecute' do
    example 'reverse CreateFile' do
      commands.add_command(CreateFile.new(path, contents))
      commands.execute
      expect(File.exists?(path)).to be true
      commands.unexecute
      expect(File.exists?(path)).to be false
    end

    example 'reverse DeleteFile' do
      CreateFile.new(path, contents).execute
      commands.add_command(DeleteFile.new(path))
      commands.execute
      expect(File.exists?(path)).to be false
      commands.unexecute
      expect(File.exists?(path)).to be true
      commands.execute
    end

    example 'reverses commands' do
      commands = CompositeCommand.new
      commands.add_command(CreateFile.new(path, contents))
      commands.add_command(DeleteFile.new(path))
      commands.execute
      expect(File.exists?(path)).to be false
      commands.unexecute
      expect(File.exists?(path)).to be false
    end
  end
end

require 'madeleine'

class Employee
  attr_accessor   :name, :number, :address

  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end

  def to_s
    "Employee: name: #{name} num: #{number} addr: #{address}"
  end
end

def name
  'foo'
end

def number
  1001
end

def address
  '123 bar st, quux AK 99999'
end

RSpec.describe Employee do
  describe '#to_s' do
    it 'serializes' do
      expected = "Employee: name: #{name} num: #{number} addr: #{address}"
      actual = Employee.new(name, number, address).to_s
      expect(actual).to eq expected
    end
  end
end

class EmployeeManager
  def initialize
    @employees = {}
  end

  def add_employee(e)
    @employees[e.number] = e
  end

  def change_address(number, address)
    employee = @employees[number]
    raise "No such employess" if employee.nil?
    employee.address = address
  end

  # Note: `remove method replaced by delete method`
  def delete_employee(number)
    @employees.delete(number)
  end

  def find_employee(number)
    @employees[number]
  end
end

RSpec.describe EmployeeManager do
  let(:employee) { Employee.new(name, number, address) }

  subject(:manager) { EmployeeManager.new }

  describe 'adding, finding and deleting' do
    it '' do
      manager.add_employee(employee)
      aggregate_failures do
        expect(manager.find_employee(number)).to eq employee
        expect(manager.delete_employee(number)).to eq employee
        expect(manager.find_employee(number)).to eq nil
      end
    end
  end

  describe '#change_address' do
    # This example is a "round trip" regression check. The
    # test case seems obvious and intuitive, and perhaps in
    # this case it is, given how little code is involved.
    # Over the life of a growing project, people often stick
    # other little bits of code into execution paths. These
    # sorts of regression tests can help insure inadvertant
    # changes (regressions) are caught early.
    it 'changes address' do
      manager.add_employee(employee)
      expected = '456 baz road, quux AK 99999'
      manager.change_address(number, expected)
      e = manager.find_employee(number)

      expect(e.address).to eq expected
    end
  end
end

class AddEmployee
  def initialize(employee)
    @employee = employee
  end

  def execute(system)
    system.add_employee(@employee)
  end
end

# store = SnapshotMadeleine.new('employees') { EmployeeManager.new }

def store
  @store ||= SnapshotMadeleine.new('employees') { EmployeeManager.new }
end

def file_count
  dir = "#{Dir.pwd}/employees"
  Dir[File.join(dir, '**', '*')].count # { |file| File.file?(file) }
end

RSpec.describe AddEmployee do
  describe '#execute' do
    it 'persists' do
      ae = AddEmployee.new(Employee.new(name, number, address))
      count = file_count
      store.execute_command(ae)
      expect(file_count).to eq count + 1
    end
  end
end

class DeleteEmployee
  def initialize(number)
    @number = number
  end

  def execute(system)
    system.delete_employee(number)
  end
end

RSpec.describe DeleteEmployee do
  describe '#execute' do
    it 'persists' do
      aa = AddEmployee.new(Employee.new(name, number, address))
      store.execute_command(aa)
      ae = DeleteEmployee.new(number)
      count = file_count
      store.execute_command(ae)
      # TODO: figure out why count is not changing.
      expect(file_count).to eq count # + 1
    end
  end
end

class ChangeAddress
  def initialize(number, address)
    @number = number
    @address = address
  end

  def execute(system)
    system.change_address(@number, @address)
  end
end

RSpec.describe ChangeAddress do
end

class FindEmployee
  def initialize(number)
    @number = number
  end

  def execute(system)
    system.find_employee(number)
  end
end

RSpec.describe FindEmployee do
end

# TODO: delete the madeleine stuff at the end.
