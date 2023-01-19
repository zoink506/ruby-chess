class Piece 
  attr_accessor :symbol, :color
end

class King < Piece
  def initialize(color)
    @symbol = 'K'
    @color = color
  end

  def update_possible_moves(board)

  end
end

class Queen < Piece
  def initialize(color)
    @symbol = 'Q'
    @color = color
  end

  def update_possible_moves(board)

  end
end

class Bishop < Piece
  def initialize(color)
    @symbol = 'B'
    @color = color
  end

  def update_possible_moves(board)

  end
end

class Knight < Piece
  def initialize(color)
    @symbol = 'N'
    @color = color
  end

  def update_possible_moves(board)

  end
end

class Rook < Piece
  def initialize(color)
    @symbol = 'R'
    @color = color
  end

  def update_possible_moves(board)

  end
end

class Pawn < Piece
  def initialize(color)
    @symbol = 'p'
    @color = color
  end

  def update_possible_moves(board)

  end
end
