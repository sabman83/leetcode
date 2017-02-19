# You are given as input a list of fruit, each with a positive
# integer weight.  You have access to a random number generator
# function “int rand(int k)” that returns a random number in 0, …,
#  k-1.  Write a function that returns a random fruit, where each
# fruit is returned with probability proportional to its weight.

# Example input:
#   apple - 7
#   banana - 5
#   kiwi - 11
require 'pry-byebug'

arr = [7,12, 23]



def get_index arr, num
end


#hash_map = {"apple" => 7, "banana" => 5, "kiwki" => 11}
def random_fruit hash_map

    freq = []
    result = {}
    fruits = hash_map.keys

    freq[0] = hash_map[fruits[0]]
    result[fruits[0]]  = 0
    for i in 1...fruits.size do
      result[fruits[i]] = 0
      freq[i] = hash_map[fruits[i]] + freq[i-1]
    end

    puts freq.to_s


    25.times do
      random_number = rand(freq.last)
      if random_number < freq.first
        puts fruits[0]
        result[fruits[0]] += 1
        next
      end

      count = 1
      while count < freq.length && random_number > freq[count] do
        count += 1
      end

      puts fruits[count]
      result[fruits[count]] += 1
    end
    puts result.to_s
end




hash_map = {"apple" => 7, "banana" => 5, "kiwki" => 11}


random_fruit hash_map
