#!/usr/bin/env ruby

require 'rspec/autorun'

# p. 144 Command Pattern
#
# I'm not sure I'm familiar with the Command Pattern,
# so this will be an interesting chapter.

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
