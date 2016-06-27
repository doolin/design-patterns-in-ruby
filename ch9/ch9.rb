#!/usr/bin/env ruby

# TODO: fill out the specs

require 'rspec'
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

  xit 'encrypts' do
    _encrypter = Encrypter.new(@key)
  end
end

reader = File.open('/tmp/message.txt')
writer = File.open('/tmp/encrypted.txt', "w")
encrypter = Encrypter.new('my secret key')
encrypter.encrypt(reader, writer)
writer.close

reader = File.open('/tmp/encrypted.txt')
writer = File.open('/tmp/decrypted.txt', "w")
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

  def eof?
    return @position >= @byte_string.length
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
      actual_byte = StringIOAdapter.new(string).getbyte
      expect(actual_byte).to eq expected_byte
    end
   end

  describe 'eof?' do
    it 'mimics end of file condition with empty string' do
      expect(StringIOAdapter.new('').eof?).to be true
    end

    it 'mimics end of file condition with non-empty string' do
      sioa = StringIOAdapter.new('123')
      (1..3).each { sioa.getbyte }
      expect(sioa.eof?).to be true
    end

    it 'returns false when not at end of string' do
      expect(StringIOAdapter.new('a').eof?).to_not be true
    end

    it 'expects .eof? to raise EOFError when traversing past end of string' do
      sioa = StringIOAdapter.new('123')
      expect {
        (1..4).each { sioa.getbyte }
      }.to raise_error(EOFError)
    end
  end
end

encrypter = Encrypter.new('XYZZY')
reader = StringIOAdapter.new('We attack at dawn')
writer = File.open('/tmp/out.txt', 'w')
encrypter.encrypt(reader, writer)
writer.close

encrypter = Encrypter.new('XYZZY')
# reader = StringIOAdapter.new('We attack at dawn')
reader = File.open('/tmp/out.txt')
writer = File.open('/tmp/in.txt', 'w')
encrypter.encrypt(reader, writer)
