#!/bin/ruby
require 'pry-byebug'

open = ['{' ,'[','(' ]
openHash = {
    '{'=> '}',
    '['=> ']',
    '('=> ')'
    }
close = ["}","]",")"]


expressions = []
t = gets.strip.to_i
for a0 in (0..t-1)
    expressions.push gets.strip
end

expressions.each do |expression|
    if expression%2 == 1
        puts 'NO'
        next
    end
    idx = expression.length/2
    n = expression.length
    balanced = true
    openIdx = []
    closeIdx = []
    expression.split('').each_index do |i|
        if open.include? expression[i]
            openIdx .push i
            next
        end
        if !(openIdx.last.nil?) && (openHash[expression[openIdx.last]] == expression[i])
            openIdx.pop
        else
            balanced = false
            break
        end
    end

    if balanced
        puts "YES"
    else
        puts "NO"
    end
end




