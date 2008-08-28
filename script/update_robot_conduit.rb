#!/usr/bin/env ruby
ENV["RAILS_ENV"] ||= "production"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
words = File.open(RAILS_ROOT+"/brit-a-z.txt").readlines
11.times do
  word = words[rand(words.size)].chomp
  Conduit.find_or_create_by_key("robot demo").update_attribute :url,  "http://www.google.com/search?q=#{word}"
  sleep 5
end
