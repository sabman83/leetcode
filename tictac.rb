class Player
  def initialize symbol
    @symbol = symbol
  end

  def play board
    x = rand(3)
    y = rand(3)
    board.mark_cell ({x: x, y: y}, @symbol)
  end
end

class Board

  def initialize
    @board = []
    for i in 0..2 do
      board.push []
    end
    self.empty_cells = 9
  end

  def mark_cell coord,symbol
    return false if game_over

    if board[row][col].nil?
      board[row][col] = symbol
      self.empty_cells -= 1
      check_winner(coord)
      return true
    end

    return false
  end

  def game_over
    self.empty_cells == 0
  end

  def print_board
    puts board
  end

  def check_winner coord


    # if any horizontal rows
    # if any vertical rows
    # if any diagonal rows
  end
end


