require 'pry-byebug'

def rand7
  num = nil
  while num.nil? do
    arr = []
    7.times do
      arr.push rand(6)
    end
    puts arr.to_s
    num = arr.index 5
  end

  num + 1
end


def rand7_2

  num = Float::INFINITY
  while num >55 do
    num =  27 * rand(4) + 9 * rand(4) + 3 * rand(4) + rand(4)
  end

  (num % 7) + 1
end


hashmap = {}
7.times do |i|
   hashmap[i+1] = 0
end


100.times do
  index = rand7_2
  hashmap[index] += 1
end

puts hashmap.to_s


