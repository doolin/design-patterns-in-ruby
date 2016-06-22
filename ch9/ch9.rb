#!/usr/bin/env ruby

class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      clear_char = reader.getc
      encrypted_char = clear_char ^ @key[key_index]
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
