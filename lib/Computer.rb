class Computer
  def get_random_move(board)
    # returns move object from possible moves list
    # to get random move, compiles all possible red moves into an array
    # generate random number to choose index
    # another random number to choose move in moves list
    sleep(1)

    moves_list = []
    board.each do |row|
      row.each do |space|
        if space != 0 && space.color == :red
          space.possible_moves.each { |move| moves_list << move }
        end
      end
    end

    random_num = rand(0..moves_list.length - 1)
    chosen_move = moves_list[random_num]
    #p "chosen_move: #{chosen_move}"
    chosen_move

  end

  def find_best_move(real_board, move_history)
    # collect all red moves
    # make the red move on a new board
    # evaluate the position with evaluate_board() method
    # choose move with the highest score
    red_pieces = real_board.find_piece("Piece", :red)
    red_moves = []
    red_pieces.each { |piece| piece.possible_moves.each { |move| red_moves << move } }

    chosen_move = nil
    max_score = -Float::INFINITY

    red_moves.each do |move|
      new_board = Marshal.load(Marshal.dump(real_board))
      new_board.move_piece_on_board(move)
      new_board.update_moves
      new_board.update_castling
      new_board.update_en_passant(move_history)
      new_board.filter_pseudo_moves

      board_score = new_board.evaluate_board
      if board_score > max_score
        max_score = board_score
        chosen_move = move
      end

      #puts "Score: #{board_score}"
      #new_board.print_board

      #puts "Chosen move: #{chosen_move}"
    end

    chosen_move
  end
end