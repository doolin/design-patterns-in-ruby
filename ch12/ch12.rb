require 'rspec'

class ClassVariableTester
  attr_reader :instance_count

  @@class_count = 0

  def initialize
    @instance_count = 0
  end

  def increment
    @@class_count += 1
    @instance_count += 1
  end

  def class_count
    @@class_count
  end

  def to_s
    "@@class_count: #{@@class_count}, @instance_count: #{@instance_count}"
  end
end


describe ClassVariableTester do
  it 'instantiates' do
    expect(ClassVariableTester.new).not_to be nil
  end

  it 'increments class and instance counts' do
    cl = ClassVariableTester.new
    cl.increment
    cl.increment
    expect(cl.class_count).to be 2
    expect(cl.instance_count).to be 2
  end
end
