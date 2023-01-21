require_relative './Board.rb'
require_relative './Player.rb'
require_relative './Computer.rb'
require_relative './Converter.rb'

class Game
  include Converter

  def initialize
    @board = Board.new
    @player = Player.new
    @computer = Computer.new
    @turn = @player
    @move_history = []
  end

  def play 
    # Loop .round until checkmate or stalemate is declared
    round
    round
    round
    round
    round
  end

  def round
    # Loop through every piece
    # Update where it can move (pseudo-legal moves)
    # 

    controlled_squares = @board.update_moves
    p controlled_squares

    @board.print_board
    first_piece = @player.player_input("Select the piece you wish to move")
    piece_coords = convert_board_to_arrays(first_piece)
    row = piece_coords[0]
    column = piece_coords[1]
    piece_on_board = @board.board[row][column]

    @board.print_board_highlighted(piece_on_board)

    second_piece = @player.player_input("Select the destination square")
    move = @board.move_piece(first_piece, second_piece)
    @move_history << move
    #p @move_history

    @turn == @player ? @turn = @computer : @turn = @player
  end
end