#!/usr/bin/env ruby

require 'rspec/autorun'
require 'uri'
require 'pry'

class Message
  attr_accessor :from, :to, :body

  def initialize(from, to, body)
    @from = from
    @to = URI.parse(to)
    @body = body
  end
end

def message
  from = 'foo'
  to = 'file:///foo/bar'
  to = 'smtp://dave@dool.in'
  body = 'baz'
  Message.new(from, to, body)
end

RSpec.describe Message do
end

require 'net/smtp'

class SmtpAdapter
  MailServerHost = 'localhost'
  MailServerPort = '25'

  def send(message)
    from_address = message.from.user + '@' + message.from.host
    to_address = message.to.user + '@' + message.to.host

    email_text = "From: #{from_address}\n"
    email_text += "To: #{to_address}\n"
    email_text += "Subject: Forwarded message\n"
    email_text += "\n"
    email_text += message.text

    Net::SMTP.start(MailServerHost, MailServerPort) do |smtp|
      smtp.send_message(email_text, from_address, to_address)
    end
  end
end

require 'net/http'

class HttpAdapter
  def send(message)
    Net::HTTP.start(message.to.host, message.to.port) do |http|
      http.post(message.to.path, message.text)
    end
  end
end

class FileAdapter
  def send(message)
    #
    # Get the path from the URL
    # and remove the leading '/'
    #
    to_path = message.to.path
    to_path.slice!(0)

    File.open(to_path, 'w') do |f|
      f.write(message.text)
    end
  end
end

class MessageGateway
  def initialize
    load_adapters
  end

  def process_message(meesage)
    adapter = adapter_for(message)
    adapter.send_message(message)
  end

  def adapter_for(message)
    protocol = message.to.scheme
    adapter_class = protocol.capitalize + 'Adapter'
    adapter_class = self.class.const_get(adapter_class)
    adapter_class.new
  end

  def load_adapters
    lib_dir = File.dirname(__FILE__)
    full_pattern = File.join(lib_dir, 'adapter', '*.rb')
    Dir.glob(full_pattern).each { |file| require file }
  end
end

RSpec.describe MessageGateway do
  describe '.new' do
    it '' do
      expect(described_class.new).not_to be nil
    end
  end
end

class DoolDotInAuthorizer
end

def camel_case(string)
  tokens = string.split('.')
  tokens.map! { |t| t.capitalize }
  tokens.join('Dot')
end

def authorizer_for(message)
  to_host = message.to.host || 'default'
  authorizer_class = camel_case(to_host) + 'Authorizer'
  authorizer_class = self.class.const_get(authorizer_class)
  authorizer_class.new
end

RSpec.describe self do
  describe 'camel_case' do
    it '' do
      expect(camel_case('dool.in')).to eq 'DoolDotIn'
    end
  end

  describe 'authorizer_for' do
    it '' do
      expect(authorizer_for(message).class).to eq DoolDotInAuthorizer
    end
  end
end
