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

  # TODO: finish this up
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
reader = File.open('/tmp/out.txt')
writer = File.open('/tmp/in.txt', 'w')
encrypter.encrypt(reader, writer)

############# page 167 ###############

# This class is included for demo purposes, as it's
# in the text, it may as well be here so we can play along.
class Renderer
  def render(text_object)
    _text = text_object.text
    _size = text_object.size
    _color = text_object.color

    ### render the text
  end
end

class TextObject
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text = text
    @size_inches = size_inches
    @color = color
  end
end

class BritishTextObject
  attr_reader :string, :size_mm, :colour

  def initialize(string, size_mm, colour)
    @string = string
    @size_mm = size_mm
    @colour = colour
  end
end

############# page 168 ###############

class BritishTextObjectAdapter < TextObject
  def initialize(bto)
    @bto = bto
  end

  # Note that the book specifies explicit `return`
  def text
    @bto.string
  end

  def size_inches
    @bto.size_mm / 25.4
  end

  def color
    @bto.colour
  end
end

describe BritishTextObjectAdapter do
  it 'instantiates correctly' do
    color = :blue
    text = 'egad'
    size = 25.4
    bto = BritishTextObject.new(text, size, color)
    btoa = BritishTextObjectAdapter.new(bto)
    expect(btoa.color).to eq color
    expect(btoa.text).to eq text
    expect(btoa.size_inches).to eq size / 25.4
  end
end


###### p. 169 Reopen BritishTextObject #######

class BritishTextObject
  def color
    colour
  end

  def text
    string
  end

  def size_inches
    size_mm / 25.4
  end
end

describe BritishTextObject do
  it 'uses monkey patched methods' do
    bto = BritishTextObject.new('egad', 25.4, :blue)
    expect(bto.colour).to eq bto.color
    expect(bto.string).to eq bto.text
    expect(bto.size_inches).to eq bto.size_mm / 25.4
  end
end


######## p. 170 ################

describe 'modifying a single instance' do
  bto = BritishTextObject.new('egad', 25.4, :blue)
  class << bto
    def color
      colour
    end

    def text
      string
    end

    def size_inches
      size_mm / 25.4
    end
  end

  it 'uses methods defined on a single instance' do
    expect(bto.colour).to eq bto.color
    expect(bto.string).to eq bto.text
    expect(bto.size_inches).to eq bto.size_mm / 25.4
  end
end
