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
end
