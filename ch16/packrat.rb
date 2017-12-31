#!/usr/bin/env ruby

require './expression'
require './parser'
require './backup'
require './data_source'

require 'pry'

def all
  All.new
end

def bigger(size)
  Bigger.new(size)
end

def filename(pattern)
  Filename.new(pattern)
end

def except(expression)
  Not.new(expression)
end

def writable
  Writable.new
end

def backup(dir, find_expression = All.new)
  puts "Backup called, source dir=#{dir} find expr=#{find_expression}"
  Backup.instance.data_sources << DataSource.new(dir, find_expression)
end

def to(backup_directory)
  puts "To called, backup dir=#{backup_directory}"
  Backup.instance.backup_directory = backup_directory
end

def interval(minutes)
  puts "Interval called, interval=#{minutes} minutes"
  Backup.instance.interval = minutes
end

# eval(File.read('backup.pr'))
# eval(File.read('single.pr'))
eval(File.read('music.pr'))
Backup.instance.run
