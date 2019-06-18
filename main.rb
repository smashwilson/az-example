#!/usr/bin/env ruby

puts "Process started successfully."

puts "Environment variables available:"
ENV.each do |key, value|
    puts " #{key}= (#{value.length})"
end

puts "ctrl-C or docker stop to exit."

loop { sleep 10000 }