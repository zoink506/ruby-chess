require 'colorize'
require_relative './Converter.rb'

module DisplayBoard
  include Converter
  # Prints the board to the terminal

  def print_board_highlighted(board, highlighted_piece = nil)

    row_number = 8

    highlighted_squares = []
    highlighted_squares = highlighted_piece.possible_moves.map { |move| move.new_position } if !highlighted_piece.nil?

    board.each_with_index do |row, i|
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
end
