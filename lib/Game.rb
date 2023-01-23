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
    20.times do
      current_round = round
      break if current_round == "exit"
    end

    puts "Game Over"
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
    # filter @possible_moves for moves that leave the friendly king in check
    # controlled squares stays the same even if the move corresponding to it is removed
    #
    # to filter moves:
    #   - for each move, duplicate board
    #   - make the move on the duplicate board
    #   - test if the friendly king is in check
    #     - if yes, discard move (illegal)
    #     - if no, keep move (legal)

    @board.filter_pseudo_moves
    @board.log_cells

    puts "REAL BOARD"
    @board.print_board
    first_piece = @player.player_input(@board.board, "Select the piece you wish to move")
    return "exit" if first_piece == "exit"

    piece_coords = convert_board_to_arrays(first_piece)
    row = piece_coords[0]
    column = piece_coords[1]
    piece_on_board = @board.board[row][column]

    puts "REAL BOARD HIGHLIGHTED"
    @board.print_board_highlighted(piece_on_board)

    second_piece = @player.second_input(piece_on_board, "Select the destination square")
    move = @board.move_piece(first_piece, second_piece)
    @move_history << move
    #p @move_history

    @turn == @player ? @turn = @computer : @turn = @player
  end
end