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
  end

  def round
    # Update where the pieces can move
    #   Piece cannot move if moving results in check
    #
    # Gather all the spots the pieces can move
    # Use the list to determine whether the king is in check
    #   Go through every piece and move the piece to every possible location
    #   Test if the king is still in check after every move
    #   If the king doesn't leave check after at least one move, it is checkmate
    # 
    # If not checkmate, check who's turn it is
    #   If it is the player's turn,
    #     Get input from the player
    #     First piece can only be a friendly piece
    #     Second piece can only be a piece in its moves list

    @board.print_board
    #first_piece = @player.player_input
    #second_piece = @player.player_input
    p convert_arrays_to_board([6, 5])
    p convert_board_to_arrays('h6')

    @turn == @player ? @turn = @computer : @turn = @player
  end
end