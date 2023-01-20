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

    @board.update_moves
    @board.print_board
    first_piece = @player.player_input("Select the piece you wish to move")
    second_piece = @player.player_input("Select the destination square")
    move = @board.move_piece(first_piece, second_piece)
    @move_history << move
    p @move_history

    @turn == @player ? @turn = @computer : @turn = @player
  end
end