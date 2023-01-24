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
    p "chosen_move: #{chosen_move}"
    chosen_move

  end
end