require 'pry'


def pow_pos(x, n)
   return 1 if n == 0
   return x * pow_pos(x, n-1)
end

def my_pow(x, n)
   return pow_pos( (1/x), -n) if(n < 0)
   pow_pos(x, n)
end
