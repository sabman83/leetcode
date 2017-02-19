class Stack

  def initialize
    @arr = []
  end

  def add data
    @arr.push data
  end

  def remove
    @arr.pop
  end

  def top
    @arr.last
  end

  def size
    @arr.size
  end
end




