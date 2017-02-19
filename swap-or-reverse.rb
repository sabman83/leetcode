# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'pry-byebug'

n = gets
n = n.to_i
s = gets
s = s.split(' ')
s.map! {|n| n.to_i}
sorted = s.sort
puts "yes" if sorted == s

def is_asc arr
    (0...arr.length-1).each do |i|
        return false if arr[i] > arr[i+1]
    end
    true
end

def swap!(arr, i, j)
    tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
end

def reverse!(arr, i, j)
    while(i<j)
      swap!(arr,i,j)
      i += 1
      j -= 1
    end
end

i=nil
j=nil

(0..n-1).each do |num|
    if(s[num] > s[num+1])
        i = num
    end
    break if !i.nil?
end


(n-1).downto(1) do |num|
    if(s[num] < s[num-1])
        j = num
    end
    break if !j.nil?
end


if !i.nil? && !j.nil?
    swap!(s, i, j)
    if is_asc(s)
        puts "yes"
        puts "swap " + (i+1).to_s +  " " + (j+1).to_s
        return
    else
        swap!(s, i, j)
        reverse!(s,i,j)
        if is_asc(s)
            puts "yes"
            puts "reverse " + (i+1).to_s +  " " + (j+1).to_s
        else
            puts "no"
        end
    end
end








