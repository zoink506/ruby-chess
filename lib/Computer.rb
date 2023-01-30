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

      sleep(0.5)
      board_score = new_board.evaluate_board
      if board_score > max_score
        max_score = board_score
        chosen_move = move
      end

      puts "Score: #{board_score}"
      new_board.print_board

      puts "Chosen move: #{chosen_move}"
    end

    chosen_move
  end

  def minimax(board, move_history, depth, maximising_player)
    #sleep(0.1)
    # maximising player is bot
    # minimising player is human
    # for each child of position
    # = for each possible move available to that side
    # REMEMBER to move the move_history to board object instead of game object

    board.update_moves
    board.update_castling
    board.update_en_passant(move_history)
    board.filter_pseudo_moves

    if depth == 0
      return board.evaluate_board
    end

    if maximising_player
      max_eval = -Float::INFINITY

      pieces = board.find_piece("Piece", :red)
      children = []
      pieces.each { |piece| piece.possible_moves.each { |move| children << move } }
      chosen_move = []

      children.each do |move|
        new_board = Marshal.load(Marshal.dump(board))
        new_board.move_piece_on_board(move)
        #new_board.print_board

        move_eval = minimax(new_board, move_history, depth - 1, false)
        max_eval = [max_eval, move_eval].max
        #p "max_eval: #{max_eval}"
      end

      return max_eval
    else
      min_eval = Float::INFINITY

      pieces = board.find_piece("Piece", :blue)
      children = []
      pieces.each { |piece| piece.possible_moves.each { |move| children << move } }
      chosen_move = []

      children.each do |move|
        new_board = Marshal.load(Marshal.dump(board))
        new_board.move_piece_on_board(move)
        #new_board.print_board

        move_eval = minimax(new_board, move_history, depth - 1, true)
        min_eval = [min_eval, move_eval].min
        #p "min_eval: #{min_eval}"

      end

      return min_eval
    end
  end
end