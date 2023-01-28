require_relative './Board.rb'
require_relative './Player.rb'
require_relative './Computer.rb'
require_relative './Converter.rb'
require_relative './Move.rb'

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

    controlled_squares = @board.update_moves
    #p controlled_squares

    @board.update_castling
    @board.update_en_passant(@move_history)
    @board.filter_pseudo_moves
    #@board.update_castling
    #@board.log_cells

    check_status = @board.test_check
    checkmate_status = @board.is_checkmate?
    stalemate_status = @board.is_stalemate?
    p check_status
    p "checkmate_status: #{checkmate_status}"
    p "stalemate_status: #{stalemate_status}"

    #puts "REAL BOARD"
    @move_history.each_with_index { |move, i| puts "Move #{i}: from #{move.original_position}, to #{move.new_position}, piece: #{move.piece.color} #{move.piece.class.name}, type: #{move.type}" }
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

      selected_move = @player.second_input(piece_on_board, "Select the destination square")
      if selected_move.type == "Promotion"
        # if the move is a promotion type, get the piece to change into from the user
        promotion = @player.get_promotion_piece
        selected_move.promoted_to = promotion

      end

      #move = @board.move_piece(first_piece, second_piece)
      #move = Move.new(piece_coords, convert_board_to_arrays(second_piece), piece_on_board)

      @board.move_piece_on_board(selected_move)
      @move_history << selected_move
      #@move_history << move
    else
      # It is the computer's turn to move
      computers_move = @computer.get_random_move(@board.board)
      #from = convert_arrays_to_board(computers_move.original_position)
      #to = convert_arrays_to_board(computers_move.new_position)

      @board.move_piece_on_board(computers_move)
      #move = @board.move_piece(from, to)
      @move_history << computers_move

    end

    @turn == @player ? @turn = @computer : @turn = @player
  end
end
