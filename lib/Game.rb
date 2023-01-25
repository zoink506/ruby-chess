require_relative './Board.rb'
require_relative './Player.rb'
require_relative './Computer.rb'
require_relative './Converter.rb'

class Game
  include Converter

  def initialize(preset_board = nil)
    @board = Board.new(preset_board)
    @player = Player.new
    @computer = Computer.new
    @turn = @player
    @move_history = []
  end

  def play 
    # Loop .round until checkmate or stalemate is declared
    40.times do
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
    #p controlled_squares

    @board.filter_pseudo_moves
    @board.log_cells

    @board.update_castling

    check_status = @board.test_check
    checkmate_status = @board.is_checkmate?
    stalemate_status = @board.is_stalemate?
    p check_status
    p "checkmate_status: #{checkmate_status}"
    p "stalemate_status: #{stalemate_status}"

    #puts "REAL BOARD"
    @board.print_board

    if @turn == @player
      first_piece = @player.player_input(@board.board, "Select the piece you wish to move")
      return "exit" if first_piece == "exit"

      piece_coords = convert_board_to_arrays(first_piece)
      row = piece_coords[0]
      column = piece_coords[1]
      piece_on_board = @board.board[row][column]

      #puts "REAL BOARD HIGHLIGHTED"
      @board.print_board_highlighted(piece_on_board)

      second_piece = @player.second_input(piece_on_board, "Select the destination square")
      move = @board.move_piece(first_piece, second_piece)
      @move_history << move
    else
      # It is the computer's turn to move
      computers_move = @computer.get_random_move(@board.board)
      from = convert_arrays_to_board(computers_move.original_position)
      to = convert_arrays_to_board(computers_move.new_position)

      move = @board.move_piece(from, to)
      @move_history << move

    end

    @turn == @player ? @turn = @computer : @turn = @player
  end
end
