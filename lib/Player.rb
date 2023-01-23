class Player
  def player_input(board, prompt)
    puts prompt
    loop do
      input = gets.chomp
      return input if validate_input(board, input) == true
    end
  end

  def validate_input(board, input)
    if input.length == 2
      if ('a'..'h').include?(input[0]) && (1..8).include?(input[1].to_i)
        return true
      end
    end

    return false
  end
end
