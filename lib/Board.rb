require_relative './Piece.rb'
require_relative './Converter.rb'
require_relative './Move.rb'
require 'colorize'

class Board
  include Converter
  attr_accessor :board

  def initialize
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

  def print_board_highlighted(highlighted_piece)
    row_number = 8
    highlighted_squares = highlighted_piece.possible_moves.map { |move| move.new_position }

    @board.each_with_index do |row, i|
      print row_number.to_s
      print " "
      row.each_with_index do |piece, j|
        if piece == 0
          if highlighted_squares.include?([i,j])
            print "|" + " • ".colorize(:background => highlighted_piece.color, :color => :white)
          else
            print "|   "
          end
        else
          piece_color = piece.color == :red ? :light_red : :light_blue

          if highlighted_squares.include?([i,j])
            print "|" + " ".colorize(:background => highlighted_piece.color) + piece.symbol.colorize(:background => highlighted_piece.color, :color => piece_color) + " ".colorize(:background => highlighted_piece.color)
          else
            print "| " + piece.symbol.send(piece_color) + " "
          end
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

    piece = @board[position1[0]][position1[1]]
    @board[position2[0]][position2[1]] = @board[position1[0]][position1[1]] # new position
    @board[position1[0]][position1[1]] = 0 # old position
    @board[position2[0]][position2[1]].position = position2

    Move.new(position1, position2, piece)
  end

  def update_moves
    red_controlled_squares = []
    blue_controlled_squares = []
    all_moves = []

    @board.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if square != 0
          squares_controlled_by_piece = square.update_possible_moves(self)
          p "#{i}-#{j}: #{squares_controlled_by_piece}"

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

    log_cells()
    controlled_squares = {
      :red => red_controlled_squares,
      :blue => blue_controlled_squares
    }

    #puts "Red controlled squares: #{controlled_squares[:red]}"
    #puts "Blue controlled squares: #{controlled_squares[:blue]}"
    return controlled_squares
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
end
