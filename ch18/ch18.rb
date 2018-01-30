#!/usr/bin/env ruby

require 'rspec/autorun'
require 'uri'

class Message
  attr_accessor :from, :to, :body
end
