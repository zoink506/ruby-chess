require_relative './Piece.rb'
require_relative './Converter.rb'
require_relative './Move.rb'
require 'colorize'

class Board
  include Converter

  def initialize
    @board = []
    8.times do |i|
      @board[i] = []
      8.times do |j| 
        @board[i][j] = 0
      end
    end

    @board[0][0] = Rook.new(:red)
    @board[0][1] = Knight.new(:red)
    @board[0][2] = Bishop.new(:red)
    @board[0][3] = Queen.new(:red)
    @board[0][4] = King.new(:red)
    @board[0][5] = Bishop.new(:red)
    @board[0][6] = Knight.new(:red)
    @board[0][7] = Rook.new(:red)
    for i in 0..7 do
      @board[1][i] = Pawn.new(:red)
    end

    @board[7][0] = Rook.new(:blue)
    @board[7][1] = Knight.new(:blue)
    @board[7][2] = Bishop.new(:blue)
    @board[7][3] = Queen.new(:blue)
    @board[7][4] = King.new(:blue)
    @board[7][5] = Bishop.new(:blue)
    @board[7][6] = Knight.new(:blue)
    @board[7][7] = Rook.new(:blue)
    for i in 0..7 do
      @board[6][i] = Pawn.new(:blue)
    end

  end

  def print_board
    row_number = 8

    @board.each do |row|
      print row_number.to_s
      print " "
      row.each do |piece|
        if piece == 0
          print "|   "
        else
          piece_color = piece.color == :red ? :light_red : :light_blue
          print "| " + piece.symbol.send(piece_color) + " "
        end
      end
      print "|"
      print "\n"

      row_number -= 1
    end

    print "   "
    8.times do |i|
      print " #{convert_column_to_letter(i)}  "
    end
    print "\n"
  end

  def move_piece(position1, position2)
    position1 = convert_board_to_arrays(position1)
    position2 = convert_board_to_arrays(position2)
    # from = @board[position1[0]][position1[1]]
    # to = @board[position2[0]][position2[1]]

    @board[position1[0]][position1[1]]
    @board[position2[0]][position2[1]] = @board[position1[0]][position1[1]]
    @board[position1[0]][position1[1]] = 0
    Move.new(position1, position2)
  end

  def update_moves
    @board.each do |row|
      row.each do |square|
        if square != 0
          square.update_possible_moves(self)
        end
      end
    end

  end
end
