require_relative './Piece.rb'
require_relative './Converter.rb'
require_relative './Move.rb'
require 'colorize'

class Board
  include Converter
  attr_accessor :board, :attacked_spaces

  def initialize(preset_board)
    # [
    #   [Rr, Nr, Br, Qr, Kr, Br, Nr, Rr],
    #   [pr, pr, pr, pr, pr, pr, pr, pr],
    #   [0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ],
    #   [0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ],
    #   [0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ],
    #   [0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ],
    #   [pb, pb, pb, pb, pb, pb, pb, pb],
    #   [Rb, Nb, Bb, Qb, Kb, Bb, Nb, Rb],
    # ]

    if preset_board.nil?
      @board = []
      8.times do |i|
        @board[i] = []
        8.times do |j| 
          @board[i][j] = 0
        end
      end

      @board[0][0] = Rook.new(:red, [0,0])
      @board[0][1] = Knight.new(:red, [0,1])
      @board[0][2] = Bishop.new(:red, [0,2])
      @board[0][3] = Queen.new(:red, [0,3])
      @board[0][4] = King.new(:red, [0,4])
      @board[0][5] = Bishop.new(:red, [0,5])
      @board[0][6] = Knight.new(:red, [0,6])
      @board[0][7] = Rook.new(:red, [0,7])
      for i in 0..7 do
        @board[1][i] = Pawn.new(:red, [1,i])
      end

      @board[7][0] = Rook.new(:blue, [7,0])
      @board[7][1] = Knight.new(:blue, [7,1])
      @board[7][2] = Bishop.new(:blue, [7,2])
      @board[7][3] = Queen.new(:blue, [7,3])
      @board[7][4] = King.new(:blue, [7,4])
      @board[7][5] = Bishop.new(:blue, [7,5])
      @board[7][6] = Knight.new(:blue, [7,6])
      @board[7][7] = Rook.new(:blue, [7,7])
      for i in 0..7 do
        @board[6][i] = Pawn.new(:blue, [6,i])
      end
    else
      piece_hash = {
        'R' => Rook,
        'N' => Knight,
        'B' => Bishop,
        'Q' => Queen,
        'K' => King,
        'p' => Pawn
      }

      @board = []
      preset_board.each_with_index do |row, i|
        @board[i] = []

        row.each_with_index do |space, j|
          if space == '0'
            @board[i][j] = 0
          elsif space.length == 2
            if piece_hash.include?(space[0])
              color = space[1] == "r" ? :red : :blue
              target_class = piece_hash[space[0]]

              @board[i][j] = target_class.new(color, [i, j])
            end
          else
            @board[i][j] = 0
          end

        end
      end

    end

    @attacked_spaces = []
  end

  # Move a piece from one spot to another
  # has no regard for whether the move is allowed, validation happens elsewhere
  def move_piece(position1, position2)
    position1 = convert_board_to_arrays(position1)
    position2 = convert_board_to_arrays(position2)
    # from = @board[position1[0]][position1[1]]
    # to = @board[position2[0]][position2[1]]

    piece = @board[position1[0]][position1[1]]
    @board[position2[0]][position2[1]] = @board[position1[0]][position1[1]] # new position
    @board[position1[0]][position1[1]] = 0 # old position
    @board[position2[0]][position2[1]].position = position2
    @board[position2[0]][position2[1]].has_moved = true

    Move.new(position1, position2, piece)
  end

  def move_piece_on_board(move)
    # takes in a move object
    # moves piece according to move object's @new_position and @original_position attributes
    # first checks the type of move
    #   - castling, en passant, promotion act differently
    #   - "Regular" type moves simply call move_piece(...)

    if move.type == "Regular" || move.type == "2 Square Move"
      #puts "REGULAR MOVE"
      # Call move_piece(...)
      row1 = move.original_position[0]
      column1 = move.original_position[1]
      row2 = move.new_position[0]
      column2 = move.new_position[1]
      from = convert_arrays_to_board([row1, column1])
      to = convert_arrays_to_board([row2, column2])

      move_piece(from, to)
      return move

    elsif move.type == "Kingside Castle"
      # Move king, then move rook
      #puts "KINGSIDE CASTLE"
      king = move.piece

      row = move.original_position[0]
      column = move.original_position[1]
      rook = @board[row][column + 3]
      move_piece(convert_arrays_to_board(king.position), convert_arrays_to_board([row, column + 2]))
      move_piece(convert_arrays_to_board(rook.position), convert_arrays_to_board([row, column + 1]))
      king.can_castle = false

    elsif move.type == "Queenside Castle"
      # move king, then move rook
      #puts "QUEENSIDE CASTLE"
      king = move.piece
      
      row = move.original_position[0]
      column = move.original_position[1]
      rook = @board[row][column - 4]
      move_piece(convert_arrays_to_board(king.position), convert_arrays_to_board([row, column - 3]))
      move_piece(convert_arrays_to_board(rook.position), convert_arrays_to_board([row, column - 2]))
      king.can_castle = false

    elsif move.type == "En Passant"
      # Move pawn to correct location
      # delete the pawn directly behind or in front of it
      row1 = move.original_position[0]
      column1 = move.original_position[1]
      row2 = move.new_position[0]
      column2 = move.new_position[1]

      move_piece(convert_arrays_to_board(move.original_position), convert_arrays_to_board(move.new_position))
      @board[row1][column2] = 0
      move.piece.has_moved = true

    elsif move.type == "Promotion"
      # Ask user which type of piece to promote to
      # Get whos turn it is
      # if player, ask for the type of piece to promote to
      
      row1 = move.original_position[0]
      column1 = move.original_position[1]
      row2 = move.new_position[0]
      column2 = move.new_position[1]



      @board[row2][column2] = move.promoted_to.new(move.piece.color, move.new_position)
      @board[row1][column1] = 0

    end

  end

  def update_moves(move_history)
    red_controlled_squares = []
    blue_controlled_squares = []
    all_moves = []

    @board.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if square != 0
          squares_controlled_by_piece = square.update_possible_moves(self)
          #p "#{i}-#{j}: #{squares_controlled_by_piece}"

          squares_controlled_by_piece.each do |spot|
            if square.color == :red
              red_controlled_squares << spot
            else # :blue
              blue_controlled_squares << spot
            end
          end
        end
      end
    end

    controlled_squares = {
      :red => red_controlled_squares,
      :blue => blue_controlled_squares
    }

    #puts "Red controlled squares: #{controlled_squares[:red]}"
    #puts "Blue controlled squares: #{controlled_squares[:blue]}"
    @attacked_spaces = controlled_squares

    self.update_castling
    self.update_en_passant(move_history)
    self.filter_pseudo_moves
  end

  def test_check
    # determines whether the current board is in check
    # returns { :red => true/false, :blue => true/false }
    check_hash = {
      :red => false,
      :blue => false
    }

    #puts "test_check"
    #p @attacked_spaces

    # find king
    blue_king = find_piece("King", :blue)[0]
    red_king = find_piece("King", :red)[0]
    #p blue_king
    #p red_king

    if @attacked_spaces[:red].include?(blue_king.position)
      check_hash[:blue] = true
    end

    if @attacked_spaces[:blue].include?(red_king.position)
      check_hash[:red] = true
    end

    check_hash
  end
  
  def find_piece(piece_type, color)
    # returns array of all pieces matching description
    matching_pieces = []

    @board.each do |row|
      row.each do |space|
        if (space.class.name == piece_type || space.class.superclass.name == piece_type ) && (space.color == color || color == :all)
          matching_pieces << space
        end
      end
    end

    matching_pieces
  end

  def log_cells
    @board.each do |row|
      row.each do |square|
        if square != 0
          square.log_cell
        end
      end
    end
  end

  def filter_pseudo_moves
    # get list of possible moves
    # make each move,
    # then check if the move would put the king in check
    # if so,
  end

  def unmake_move(move)

  end

  def is_checkmate?
    # If the king is in check and there are no legal moves for that side, it is checkmate
    check_status = test_check()

    if check_status[:red] == true
      red_pieces = find_piece("Piece", :red)
      red_moves = []
      red_pieces.each { |piece| piece.possible_moves.each { |move| red_moves << move } }
      #red_moves.each { |move| p "#{move}: |  Original Position: #{move.original_position} |  New Position: #{move.new_position} |  Piece: #{move.piece}" }
      if red_moves.empty?
        # checkmate!
        puts "CHECKMATE"
        return :red
      else
        puts "NOT CHECKMATE"
      end
    end

    if check_status[:blue] == true
      blue_pieces = find_piece("Piece", :blue)
      blue_moves = []
      blue_pieces.each { |piece| piece.possible_moves.each { |move| blue_moves << move } }
      if blue_moves.empty?
        return :blue
      end
    end

    nil
  end

  def is_stalemate?
    # If the king is not in check, and there are no legal moves, stalemate is declared
    red_pieces = find_piece("Piece", :red)
    blue_pieces = find_piece("Piece", :blue)
    check_status = test_check()

    red_moves = []
    red_pieces.each { |piece| piece.possible_moves.each { |move| red_moves << move } }
    #p "red moves: #{red_moves}"

    blue_moves = []
    blue_pieces.each { |piece| piece.possible_moves.each { |move| blue_moves << move } }
    #p "blue moves: #{blue_moves}"

    if red_moves.empty? && !check_status[:red]
      puts "red is in stalemate"
      return :red
    end

    if blue_moves.empty? && !check_status[:blue]
      puts "blue is in stalemate"
      return :blue
    end

    nil
  end

  def update_castling
    kings = find_piece("King", :all)
    #p kings
    kings.each { |king| king.update_castling_rights(self) }
  end

  def update_en_passant(move_history)
    # Look at the last move in the move history
    # If it is a pawn moving 2 spaces
    # check the 2 squares beside it for an enemy pawn
    # if the square has an enemy pawn, create a new move with type "En Passant"
    latest_move = move_history[-1]

    if !latest_move.nil?
      if latest_move.type == "2 Square Move" && latest_move.piece.class.name == "Pawn"
        #puts "the latest move is a 2 square move by a pawn"

        row = latest_move.new_position[0]
        column = latest_move.new_position[1]

        right_piece = @board[row][column + 1]

        dir = latest_move.piece.color == :red ? -1 : 1

        if column - 1 >= 0
          left_piece = @board[row][column - 1]
          if left_piece != 0
            #puts "left_piece is not 0"
            move = Move.new([row, column - 1], [row + (1 * dir), column], left_piece, "En Passant")
            left_piece.possible_moves << move

            #left_piece.possible_moves.each { |move| puts "Move: #{move.original_position}, #{move.new_position}, #{move.piece.color} #{move.piece.class.name}, #{move.type}" }
          end
        end

        if column + 1 <= @board[row].length - 1
          if right_piece != 0
            #puts "right_piece is not 0"
            move = Move.new([row, column + 1], [row + (1 * dir), column], right_piece, "En Passant")
            right_piece.possible_moves << move

            #right_piece.possible_moves.each { |move| puts "Move: #{move.original_position}, #{move.new_position}, #{move.piece.color} #{move.piece.class.name}, #{move.type}" }
          end
        end
      end
    end 
  end

  def evaluate_board()
    # material and mobility evaluation
    # each square of possible movement is worth 20?
    # +score is good for computer
    # -score is good for player

    red_score = 0
    blue_score = 0
    mobility_score = 5

    piece_scores = {
      King => 0,
      Queen => 900,
      Rook => 500,
      Bishop => 300,
      Knight => 300,
      Pawn => 100
    }

    red_pieces = find_piece("Piece", :red)
    blue_pieces = find_piece("Piece", :blue)

    red_moves = []
    blue_moves = []

    red_pieces.each do |piece|
      if piece.class.name == "Pawn"
        # Pawns in center are better than pawns not in center
        # but pawns in outer columns shuld stay back
        pawn_bitboard = [
          [1, 1,   1,   1,   1,   1, 1, 1],
          [1, 1,   1,   1,   1,   1, 1, 1],
          [1, 1, 1.5, 1.5, 1.5, 1.5, 1, 1],
          [1, 1, 1.5, 2.5, 2.5, 1.5, 1, 1],
          [1, 1, 1.5, 2.5, 2.5, 1.5, 1, 1],
          [1, 1, 1.5, 1.5, 1.5, 1.5, 1, 1],
          [1, 1,   1,   1,   1,   1, 1, 1],
          [1, 1,   1,   1,   1,   1, 1, 1],
        ]

        material_points = piece_scores[piece.class]
        row = piece.position[0]
        column = piece.position[1]
        red_score += material_points * pawn_bitboard[row][column]

      else
        red_score += piece_scores[piece.class]
      end

      piece.possible_moves.each { |move| red_moves << move }
    end

    blue_pieces.each do |piece|
      blue_score += piece_scores[piece.class]

      piece.possible_moves.each { |move| blue_moves << move }
    end

    red_score += red_moves.length * mobility_score
    blue_score += blue_moves.length * mobility_score

    score = red_score - blue_score
    return score

  end
end
