require_relative './Move.rb'
require 'colorize'

class Piece
  attr_accessor :symbol, :color, :position, :original_position, :possible_moves, :has_moved

  def log_cell
    color = @color == :red ? :light_red : :light_blue
    puts self.class.name.send(color)
    puts "position: #{@position}"
    puts "possible_moves: #{@possible_moves}"

    puts "\n\n"
  end

  def search(board, horizontal_dir, vertical_dir, distance = 8)
    # position = where to start the search from
    # horizontal_dir = -1 (left), 0 (same), 1 (right)
    # vertical_dir = -1 (up), 0 (same), 1 (right)
    # distance = how many squares to look in that direction
    row = @position[0] + (1 * vertical_dir)
    column = @position[1] + (1 * horizontal_dir)
    moves = []

    count = 1
    while count < distance + 1
      break if (row < 0 || row > board.length - 1) || (column < 0 || column > board[0].length - 1)
      
      square = board[row][column]
      move = Move.new(@position, [row, column], self)
      #p square

      if square != 0 # is a piece
        if square.color != @color
          moves << move
          #moves << [row, column]   #FOR TESTING PURPOSES, COMMENT OUT LINE ABOVE
        end

        break # is friendly piece, stop searching
      else # not a piece
        moves << move
        #moves << [row, column]
      end

      row += 1 * vertical_dir
      column += 1 * horizontal_dir
      count += 1
    end

    return moves
  end
end

class King < Piece
  attr_accessor :can_castle

  def initialize(color, position)
    @symbol = 'K'
    @color = color
    @position = position
    @original_position = position
    @possible_moves = []
    @can_castle = true
    @has_moved = false
  end

  def update_possible_moves(board)
    moves_available = []
    controlled_squares = []

    top = search(board.board, 0, -1, 1)
    top.each do |move|
      moves_available << move
      controlled_squares << move.new_position
    end

    bottom = search(board.board, 0, 1, 1)
    bottom.each do |move|
      moves_available << move
      controlled_squares << move.new_position
    end

    left = search(board.board, -1, 0, 1)
    left.each do |move|
      moves_available << move
      controlled_squares << move.new_position
    end

    right = search(board.board, 1, 0, 1)
    right.each do |move|
      moves_available << move
      controlled_squares << move.new_position
    end

    top_left = search(board.board, -1, -1, 1)
    top_left.each do |move|
      moves_available << move
      controlled_squares << move.new_position
    end

    top_right = search(board.board, 1, -1, 1)
    top_right.each do |move|
      moves_available << move
      controlled_squares << move.new_position
    end

    bottom_left = search(board.board, -1, 1, 1)
    bottom_left.each do |move|
      moves_available << move
      controlled_squares << move.new_position
    end

    bottom_right = search(board.board, 1, 1, 1)
    bottom_right.each do |move|
      moves_available << move
      controlled_squares << move.new_position
    end

    @possible_moves = []
    moves_available.each { |move| @possible_moves << move }
    return controlled_squares
  end

  def update_castling_rights(board)
    # Update castling rights.
    # if king is in its original position,
    # and the rook is in its original position,
    # and all the spaces between king and rook are empty and not controlled by other color
    # and the king is not in check,
    # and the resulting position would not put the king in check,
    # then set its castling rights to true
    check_status = board.test_check

    if !check_status[@color]
      #puts "#{color} KING IS NOT IN CHECK"

      if !@has_moved
        #puts "#{@color} KING HAS NOT MOVED"
        row = @position[0]
        column = @position[1]
        opposite_color = @color == :red ? :blue : :red

        # King side castle
        rook = board.board[row][column + 3]

        if rook.class.name == "Rook" && !rook.has_moved && rook.color == @color
          #puts "#{@color} ROOK HAS NOT MOVED"
          if board.board[row][column + 1] == 0 && board.board[row][column + 2] == 0
            #puts "ALL SPACES BETWEEN #{@color} KING ARE EMPTY"

            if board.attacked_spaces[opposite_color].include?([row, column + 1]) || board.attacked_spaces[opposite_color].include?([row, column + 2])
              #puts "SPACES BETWEEN #{@color} KING ARE BEING ATTACKED"
            else
              #puts "SPACES BETWEEN #{@color} KING ARE NOT BEING ATTACKED"
              # create a new move to castle kingside
              # add new attribute "type" to move class which describes:
              #   - Regular moves (sliding pieces, knight, pawn)
              #   - Promotion
              #   - En Passant
              #   - Castling
              #   - 2 square move for pawn??
              king_castle = Move.new(@position, [row, column + 3], self, "Kingside Castle")
              @possible_moves << king_castle

            end

          end

        end

        # Queen side castle
        rook = board.board[row][column - 4]
        
        if rook.class.name == "Rook" && !rook.has_moved && rook.color == @color
          #puts "#{@color} queenside piece is a rook of the same color that has not moved"

          if board.board[row][column - 3] == 0 && board.board[row][column - 2] == 0 && board.board[row][column - 1] == 0
            #puts "#{@color} queenside squares are all empty"

            if board.attacked_spaces[opposite_color].include?([row, column - 3]) || board.attacked_spaces[opposite_color].include?([row, column - 2]) || board.attacked_spaces[opposite_color].include?([row, column - 1])
              #puts "#{color} queenside squares are controlled by enemy"

            else
              #puts "#{color} queenside squares are not controlled by enemy"

              queen_castle = Move.new(@position, [row, column - 4], self, "Queenside Castle")
              @possible_moves << queen_castle
            end

          end
        end

      end
    end

  end
end

class Queen < Piece
  def initialize(color, position)
    @symbol = 'Q'
    @color = color
    @position = position
    @original_position = position
    @possible_moves = []
    @has_moved = false
  end

  def update_possible_moves(board)
    moves_available = []
    controlled_squares = []

    top = search(board.board, 0, -1)
    bottom = search(board.board, 0, 1)
    left = search(board.board, -1, 0)
    right = search(board.board, 1, 0)
    top_left = search(board.board, -1, -1)
    top_right = search(board.board, 1, -1)
    bottom_left = search(board.board, -1, 1)
    bottom_right = search(board.board, 1, 1)

    top.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    bottom.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    left.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    right.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    top_left.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    top_right.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    bottom_left.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    bottom_right.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    @possible_moves = []
    moves_available.each { |move| @possible_moves << move }
    return controlled_squares
  end
end

class Bishop < Piece
  def initialize(color, position)
    @symbol = 'B'
    @color = color
    @position = position
    @original_position = position
    @possible_moves = []
    @has_moved = false
  end

  def update_possible_moves(board)
    moves_available = []
    controlled_squares = []

    top_left = search(board.board, -1, -1)
    top_right = search(board.board, 1, -1)
    bottom_left = search(board.board, -1, 1)
    bottom_right = search(board.board, 1, 1)

    top_left.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    top_right.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    bottom_left.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    bottom_right.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      p recipient_piece if recipient_piece.class.name == "King"
      controlled_squares << move.new_position
    end

    @possible_moves = []
    moves_available.each { |move| @possible_moves << move }
    return controlled_squares
  end
end

class Knight < Piece
  def initialize(color, position)
    @symbol = 'N'
    @color = color
    @position = position
    @original_position = position
    @possible_moves = []
    @has_moved = false
  end

  def update_possible_moves(board)
    moves_available = []
    controlled_squares = []
    row = @position[0]
    column = @position[1]

    if (row - 2 >= 0) && (column - 1 >= 0)
      top_left = board.board[row - 2][column - 1]

      if top_left == 0 || (top_left != 0 && top_left.color != @color)
        moves_available << Move.new(@position, [row - 2, column - 1], self) if top_left.class.name != "King"
        controlled_squares << [row - 2, column - 1]
      end
    end

    #top_right = board.board[row - 2][column + 1] if (row - 2 >= 0) && (column + 1 <= board.board[0].length - 1)
    if (row - 2 >= 0) && (column + 1 <= board.board[0].length - 1)
      top_right = board.board[row - 2][column + 1]

      if top_right == 0 || (top_right != 0 && top_right.color != @color)
        moves_available << Move.new(@position, [row - 2, column + 1], self) if top_right.class.name != "King"
        controlled_squares << [row - 2, column + 1]
      end
    end

    #bottom_left = board.board[row + 2][column - 1] if (row + 2 <= board.board.length - 1) && (column - 1 >= 0)
    if (row + 2 <= board.board.length - 1) && (column - 1 >= 0)
      bottom_left = board.board[row + 2][column - 1]

      if bottom_left == 0 || (bottom_left != 0 && bottom_left.color != @color)
        moves_available << Move.new(@position, [row + 2, column - 1], self) if bottom_left.class.name != "King"
        controlled_squares << [row + 2, column - 1]
      end
    end

    #bottom_right = board.board[row + 2][column + 1] if (row + 2 <= board.board.length - 1) && (column + 1 <= board.board[0].length - 1)
    if (row + 2 <= board.board.length - 1) && (column + 1 <= board.board[0].length - 1)
      bottom_right = board.board[row + 2][column + 1]

      if bottom_right == 0 || (bottom_right != 0 && bottom_right.color != @color)
        moves_available << Move.new(@position, [row + 2, column + 1], self) if bottom_right.class.name != "King"
        controlled_squares << [row + 2, column + 1]
      end
    end

    #left_top = board.board[row - 1][column - 2] if (row - 1 >= 0) && (column - 2 >= 0)
    if (row - 1 >= 0) && (column - 2 >= 0)
      left_top = board.board[row - 1][column - 2]

      if left_top == 0 || (left_top != 0 && left_top.color != @color)
        moves_available << Move.new(@position, [row - 1, column - 2], self) if left_top.class.name != "King"
        controlled_squares << [row - 1, column - 2]
      end
    end

    #left_bottom = board.board[row + 1][column - 2] if (row + 1 <= board.board.length - 1) && (column - 2 >= 0)
    if (row + 1 <= board.board.length - 1) && (column - 2 >= 0)
      left_bottom = board.board[row + 1][column - 2]

      if left_bottom == 0 || (left_bottom != 0 && left_bottom.color != @color)
        moves_available << Move.new(@position, [row + 1, column - 2], self) if left_bottom.class.name != "King"
        controlled_squares << [row + 1, column - 2]
      end
    end

    #right_top = board.board[row - 1][column + 2] if (row - 1 >= 0) && (column + 2 <= board.board[0].length - 1)
    if (row - 1 >= 0) && (column + 2 <= board.board[0].length - 1)
      right_top = board.board[row - 1][column + 2]

      if right_top == 0 || (right_top != 0 && right_top.color != @color)
        moves_available << Move.new(@position, [row - 1, column + 2], self) if right_top.class.name != "King"
        controlled_squares << [row - 1, column + 2]
      end
    end

    #right_bottom = board.board[row + 1][column + 2] if (row + 1 <= board.board.length - 1) && (column + 2 <= board.board[0].length)
    if (row + 1 <= board.board.length - 1) && (column + 2 <= board.board[0].length - 1)
      right_bottom = board.board[row + 1][column + 2]

      if right_bottom == 0 || (right_bottom != 0 && right_bottom.color != @color)
        moves_available << Move.new(@position, [row + 1, column + 2], self) if right_bottom.class.name != "King"
        controlled_squares << [row + 1, column + 2]
      end
    end

    @possible_moves = []
    moves_available.each do |move|
      @possible_moves << move
    end

    return controlled_squares
  end
end

class Rook < Piece
  def initialize(color, position)
    @symbol = 'R'
    @color = color
    @position = position
    @original_position = position
    @possible_moves = []
    @has_moved = false
  end

  def update_possible_moves(board)
    controlled_squares = []  # coordinates, return this to test for check
    moves_available = []     # Move objects, set to @possible_moves

    top = search(board.board, 0, -1)
    bottom = search(board.board, 0, 1)
    left = search(board.board, -1, 0)
    right = search(board.board, 1, 0)

    top.each do |move| 
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    bottom.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    left.each do |move| 
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    right.each do |move|
      recipient_piece = board.board[move.new_position[0]][move.new_position[1]]
      moves_available << move if recipient_piece.class.name != "King"
      controlled_squares << move.new_position
    end

    @possible_moves = []
    moves_available.each { |move| @possible_moves << move }
    return controlled_squares
  end
end

class Pawn < Piece
  def initialize(color, position)
    @symbol = 'p'
    @color = color
    @position = position
    @original_position = position
    @possible_moves = []
    @has_moved = false
  end

  def update_possible_moves(board)
    moves_available = []
    diagonals = []

    row = @position[0]
    column = @position[1]
    @color == :red ? dir = 1 : dir = -1

    if row + (1 * dir) >= 0 && row + (1 * dir) <= board.board.length - 1

      one_square_ahead = board.board[row + (1 * dir)][column]
      if one_square_ahead == 0
        threshold = @color == :red ? 7 : 0
        if row + (1 * dir) == threshold
          moves_available << Move.new(@position, [row + (1 * dir), column], self, "Promotion", Queen)
          moves_available << Move.new(@position, [row + (1 * dir), column], self, "Promotion", Rook)
          moves_available << Move.new(@position, [row + (1 * dir), column], self, "Promotion", Bishop)
          moves_available << Move.new(@position, [row + (1 * dir), column], self, "Promotion", Knight)
        else
          moves_available << Move.new(@position, [row + (1 * dir), column], self)
        end
        #moves_available << [row + (1 * dir), column]

        if @position == @original_position && row + (2 * dir) >= 0 && row + (2 * dir) <= board.board.length - 1
          # check 2 spaces ahead
          two_squares_ahead = board.board[row + (2 * dir)][column]
          if two_squares_ahead == 0
            # not a piece, move available
            moves_available << Move.new(@position, [row + (2 * dir), column], self, "2 Square Move")
            #moves_available << [row + (2 * dir), column]
          end
        end
      end

      # Check diagonals 
      # if a piece is there, add the move to diagonals[]
      # return diagonals (because forward moves don't effect check/checkmate, while diagonals do)
      if column - 1 >= 0
        left_diagonal = board.board[row + (1 * dir)][column - 1]

        if left_diagonal == 0
          diagonals << [row + (1 * dir), column - 1]
        else
          # left_diagonal is a piece
          # if it is an enemy piece, add it to diagonals[] and possible_moves[]
          if left_diagonal.color != @color
            diagonals << [row + (1 * dir), column - 1]
            moves_available << Move.new(@position, [row + (1 * dir), column - 1], self) if left_diagonal.class.name != "King"
          end
        end
      end

      if column + 1 <= board.board[row].length - 1
        right_diagonal = board.board[row + (1 * dir)][column + 1]

        if right_diagonal == 0
          diagonals << [row + (1 * dir), column + 1]
        else
          if right_diagonal.color != @color
            diagonals << [row + (1 * dir), column + 1]
            moves_available << Move.new(@position, [row + (1 * dir), column + 1], self) if right_diagonal.class.name != "King"
          end
        end
      end
    end

    @possible_moves = []
    moves_available.each { |move| @possible_moves << move }
    return diagonals
  end
end
