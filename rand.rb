require 'pry-byebug'
def random_7
  while true do
    arr = []
    for i in 0..6 do
      arr[i] = rand(1..5)
    end

    sorted_arr = arr.sort
    max = sorted_arr.last

    index = arr.each_index.select{|i| arr[i] == max}
    break if index.length == 1
  end
  index.first + 1
end

def test_random_7

  count = {}
  for i in 1..7 do
    count[i] = 0
  end

  puts "Initialzing all count to 0 ", count

  for i in 1..1000 do
    count[random_7] += 1
  end

  puts "error in distribution " unless count.values.inject(0, :+) == 1000
  puts "Distribution of numbers", count

end

test_random_7
