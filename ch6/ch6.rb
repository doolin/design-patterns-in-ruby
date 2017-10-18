#!/usr/bin/env ruby

require 'rspec/autorun'

class Task
end

RSpec.describe Task do
  describe '.new' do
    it 'instantiates' do
      expect(Task.new).to_not be nil
    end
  end
end
