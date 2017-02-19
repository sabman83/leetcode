# you can write to stdout for debugging purposes, e.g.
# puts "this is a debug message"


def solution(a)
  # write your code in Ruby 2.2
  sums = [nil]
  soln = 0

  currSum = 0
  a.each do |num,index|
    currSum += num
    sums.push currSum
    if currSum == 0
      soln += 1
    end
  end

  for i in (1...a.size) do
    x = a[i-1]
    for j in (i+1...a.size) do
      sums[j] = sums[j] - x
      soln += 1 if sums[j] == 0
      break if soln > 1000000000
    end
    break if soln > 1000000000
  end

  #if 0 exists in the array add [index,index]
  idx = a.index(0)
  soln += 1 if !(idx.nil?)

  soln > 1000000000 ? -1 : soln

end


a =[2,-2,3,0,4,-7]

def soln a

  partial_sums = {}
  partial_sums[0] = 1

  sum =0
  count = 0

  for i in (0...a.size) do
    sum += a[i]
    if partial_sums[sum].nil?
      partial_sums[sum] = 1
    else
      count += partial_sums[sum]
      partial_sums[sum] += 1
    end
  end

  puts count.to_s
end

soln a













