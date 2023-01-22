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
    check_status = @board.test_check
    p check_status
    #p controlled_squares

    # LIST OF PSEUDO LEGAL MOVES DONE
    # filter @possible_moves for moves that leave the friendly king in check or take the enemy king
    # controlled squares stays the same even if the move corresponding to it is removed
    #
    # to filter moves:
    #   - for each move, duplicate board
    #   - make the move on the duplicate board
    #   - test if the friendly king is in check
    #     - if yes, discard move (illegal)
    #     - if no, keep move (legal)

    #@board.filter_pseudo_moves


    puts "REAL BOARD"
    @board.print_board
    first_piece = @player.player_input("Select the piece you wish to move")
    piece_coords = convert_board_to_arrays(first_piece)
    row = piece_coords[0]
    column = piece_coords[1]
    piece_on_board = @board.board[row][column]

    puts "REAL BOARD HIGHLIGHTED"
    @board.print_board_highlighted(piece_on_board)

    second_piece = @player.player_input("Select the destination square")
    move = @board.move_piece(first_piece, second_piece)
    @move_history << move
    #p @move_history

    @turn == @player ? @turn = @computer : @turn = @player
  end
end