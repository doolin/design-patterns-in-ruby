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
end

RSpec.describe CreateFile do
  describe '#execute' do
    it 'writes a file to /tmp' do
      path = '/tmp/testem.txt'
      contents = 'quux'
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
    File.delete(@path)
  end
end

RSpec.describe DeleteFile do
  describe '#execute' do
  end
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
  end
end

class CompositeCommand < Command
  def initialize
    @commands = []
  end
end
