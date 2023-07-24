require_relative './Board.rb'
require_relative './Player.rb'
require_relative './Computer.rb'
require_relative './Converter.rb'
require_relative './Move.rb'
require_relative './DisplayBoard.rb'

class Game
  include Converter
  include DisplayBoard

  def initialize(preset_board = nil)
    @board = Board.new(preset_board)
    @player = Player.new
    @computer = Computer.new
    @turn = @player
    @piece_selected = false
    @move_history = []
  end

  def play 
    # Loop .round until checkmate or stalemate is declared
    40.times do
      current_round = round
      break if current_round == "exit"
    end

    print_board(@board.board)
    puts "Game Over"
  end

  def round
    @board.update_moves(@move_history)

    check_status = @board.test_check
    checkmate_status = @board.is_checkmate?
    stalemate_status = @board.is_stalemate?

    return checkmate_status if !checkmate_status.nil?
    return stalemate_status if !stalemate_status.nil?

    p check_status
    p "checkmate_status: #{checkmate_status}"
    p "stalemate_status: #{stalemate_status}"

    #puts "REAL BOARD"
    @move_history.each_with_index { |move, i| puts "Move #{i}: from #{move.original_position}, to #{move.new_position}, piece: #{move.piece.color} #{move.piece.class.name}, type: #{move.type}, piece_taken: #{move.piece_taken}, promoted_to: #{move.promoted_to}" }
    print_board_highlighted(@board.board)

    if @turn == @player
      first_piece = @player.player_input(@board.board, "Select the piece you wish to move")
      return "exit" if first_piece == "exit"

      piece_coords = convert_board_to_arrays(first_piece)
      row = piece_coords[0]
      column = piece_coords[1]
      piece_on_board = @board.board[row][column]

      print_board_highlighted(@board.board, piece_on_board)

      selected_move = @player.second_input(piece_on_board, "Select the destination square")
      if selected_move.type == "Promotion"
        # if the move is a promotion type, get the piece to change into from the user
        promotion = @player.get_promotion_piece
        selected_move.promoted_to = promotion

      end

      @board.move_piece_on_board(selected_move)
      @move_history << selected_move

      print_board_highlighted(@board.board)
      puts "Unmaking move"
      @board.unmake_move(@move_history[-1])
    else

      computers_move = @computer.get_random_move(@board.board)

      @board.move_piece_on_board(computers_move)
      @move_history << computers_move
    end

    @turn == @player ? @turn = @computer : @turn = @player
  end
end
