#!/bin/ruby
require 'pry-byebug'
a = gets.strip
b = gets.strip

arrA = a.split('')
arrB = b.split('')

arrA = arrA.sort
arrB = arrB.sort

result = 0

return result if arrA == arrB
hash = {}
arrA.each do |char|
    if hash[char].nil?
        hash[char] = 1
    else
        hash[char] += 1
    end
end
binding.pry
arrB.each do |char|
    if hash[char].nil?
        result += 1
    else
        hash[char] -= 1
    end
end

result += hash.values.reduce(:+)

puts result.to_s
