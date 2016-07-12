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


# p. 209
describe 'class methods and instance methods are different' do
  class SomeClass
    def a_method
      puts 'hello from a method'
    end
  end

  it 'raises when invoking an instance method from a class' do
    expect { SomeClass.a_method }.to raise_error(NoMethodError)
  end
end

## A note for myself on self following up on p. 209
describe 'self vs. self' do
  class Foo
    def self.self_id
      # self from class
      self.object_id
    end

    def instance_id
      # self from instance
      self.object_id
    end
  end

  it 'does not have the same id for the class as the object' do
    class_id = Foo.object_id
    instance = Foo.new
    instance_id = instance.object_id
    expect(Foo.self_id).to eq class_id
    expect(instance.instance_id).to eq instance_id
    expect(instance_id).not_to eq class_id
  end
end

# p. 210
class SomeClass
  def self.class_level_method
    'class_level_method'
  end

  def SomeClass.other_class_method
    'other_class_method'
  end
end

describe SomeClass do
  it 'calls class method defined with self' do
    expect(SomeClass.class_level_method).to eq 'class_level_method'
  end

  it 'calls class method defined with class name' do
    expect(SomeClass.class_level_method).to eq 'class_level_method'
  end
end


# p. 211
class SimpleLogger
  attr_accessor :level

  ERROR = 1
  WARNING = 2
  INFO = 3

  def initialize
    @log = File.open('log.txt', 'w')
    @level = WARNING
  end

  def error(msg)
    @log.puts(msg)
    @log.flush
  end

  def warning(msg)
    @log.puts(msg) if @level >= WARNING
    @log.flush
  end

  def info(msg)
    @log.puts(msg) if @level >= INFO
    @log.flush
  end

  # p. 212
  # @@instance = SimpleLogger.new
  @@instance = new

  def self.instance
    @@instance
  end

  # p.213
  private_class_method :new
end

describe SimpleLogger do
  it 'creates a single instance of itself' do
    instance1 = SimpleLogger.instance
    instance2 = SimpleLogger.instance
    expect(instance1).to eq instance2
  end

  it 'instantiating directly raises NoMethodError' do
    expect { SimpleLogger.new }.to raise_error(NoMethodError)
  end
end
