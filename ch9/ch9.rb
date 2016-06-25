#!/usr/bin/env ruby

require 'pry'

class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      encrypted_char = reader.getbyte ^ @key.getbyte(key_index)
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end

describe Encrypter do
  before :each do
    @key = [1, 2, 3]
  end

  it 'instantiates' do
    expect(Encrypter.new(@key)).to_not be nil
  end

  it 'encrypts' do
    encrypter = Encrypter.new(@key)
  end
end

reader = File.open('/tmp/message.txt')
writer = File.open('/tmp/encrypted.txt', "w")
encrypter = Encrypter.new('my secret key')
encrypter.encrypt(reader, writer)

class StringIOAdapter
  def initialize(string)
    @byte_string = string.bytes
    @position = 0
  end

  def getbyte
    raise EOFError if @position >= @byte_string.length

    ch = @byte_string[@position]
    @position += 1
    ch
  end
end

describe StringIOAdapter do
  it 'instantiates' do
    expect(StringIOAdapter.new('string')).not_to be nil
  end

  describe 'getbyte' do
    it 'gets a byte' do
      string = 'string'
      expected_byte = string.bytes[0]
      actual_byte = StringIOAdapter.new('string').getbyte
      expect(actual_byte). to eq expected_byte
    end
  end
end
