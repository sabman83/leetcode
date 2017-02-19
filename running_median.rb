#!/bin/ruby
require "pry-byebug"

n = gets.strip.to_i
a = Array.new(n)
for a_i in (0..n-1)
    a[a_i] = gets.strip.to_i
    puts a
    binding.pry
    a = a.sort

    if((a_i % 2) == 0)
        puts (( a[(a_i/2)-1] + a[a_i/2] ) / 2).to_s
    else
        puts (a[a_i/2])
    end
end
