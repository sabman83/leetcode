#
# Your previous Plain Text content is preserved below:
#
# 99 fair coins, 1 biased coin (double sided heads)
# select 1 at random - flip it 10 times - record 10 heads in a row
#
# Probability that you selected the biaed coin?
#
# a => the coin is biased
# b => event of getting 10 heads
#
# P(a|b)
#
# P(b|a)  = 1
#
# p(a) = 1 / 100
#
# p(b) = 99/100 * (0.5 ^ 10) + 1/100 * 1
#
# P(a|b) = P(b|a)*P(a)/P(b)
#
# 91%


def biased_coin
  return 'H'
end


def unbiased_coin
  num  = rand(2)
  return 'H' if num == 0
  return 'T' if num == 1
end


def select_coin
  num = rand(100)
  return 'unbiased' if num > 0
  return 'biased'
end


def simulator
  coin = select_coin
  flips = []
  if coin == 'unbiased'
    10.times do
      flips.push unbiased_coin
    end
  else
    10.times do
      flips.push biased_coin
    end
  end
  {type: coin, flips: flips}
end


coin_with_ten_heads = {'biased' => 0, 'unbiased' => 0}
1000000.times do
  result = simulator
  tail_flips = result[:flips].select {|item| item == 'T'}
  if tail_flips.size == 0
    coin_with_ten_heads[result[:type]] += 1
  end
end

puts (100 *
        (coin_with_ten_heads['biased'].to_f /
          (coin_with_ten_heads['biased'].to_f + coin_with_ten_heads['unbiased'].to_f)
        )
    ).to_s




