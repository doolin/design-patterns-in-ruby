#!/usr/bin/env ruby

require 'rspec/autorun'
require 'uri'

class Message
  attr_accessor :from, :to, :body

  def initialize(from, to, body)
    @from = from
    @to = URI.parse(to)
    @body = body
  end
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
  end
end
