require 'pry-byebug'

def index_all(char, str)
    arr = []
    idx = 0
    while(!str.index(char, idx).nil?) do
        arr.push str.index(char, idx)
        idx = arr.last + 1
    end
    arr
end

def num_distinct(s, t)
    indices = {}
    for i in 0...t.size do
        indices[i] = index_all(t[i],s)
    end
    arr = []
    for i in 0...indices[0].size do
      arr[i] = [indices[0][i]]
    end
    binding.pry
end

num_distinct("ddaddeda", "dda")
