#!/usr/bin/env ruby

require 'pry'

class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      clear_char = reader.getc
      binding.pry
      encrypted_char = clear_char.bytes.first ^ @key[key_index].bytes.first
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
end

describe StringIOAdapter do
end
