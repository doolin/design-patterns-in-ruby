require 'rspec'

class ClassVariableTester
  @@class_count = 0

  def initialize
    @instance_count = 0
  end

  def increment
    @@class_count += 1
    @instance_count += 1
  end

  def to_s
    "@@class_count: #{@@class_count}, @instance_count: #{@instance_count}"
  end
end

describe ClassVariableTester do
  it 'instantiates' do
    expect(ClassVariableTester.new).not_to be nil
  end
end
