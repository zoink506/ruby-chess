require_relative './Converter.rb'

# RETURN THE MOVE OBJECT THAT HAS BEEN SELECTED, NOT THE INPUT!!!

class Player
  include Converter
  
  def player_input(board, prompt)
    puts prompt
    loop do
      input = gets.chomp
      return input if input == "exit"
      #return input if validate_input(input)

      if validate_input(input)
        if validate_piece(board, input)
          return input
        end
      end

    end
  end

  def validate_piece(board, input)
    input = convert_board_to_arrays(input)
    row = input[0]
    column = input[1]
    piece = board[row][column]
    if piece != 0
      if piece.color == :blue
        if !piece.possible_moves.empty?
          return true
        end
      end
    end

    false
  end

  def validate_input(input)
    # First input:
    #   - First, check that the input is a valid position
    #   - Then, check if the piece is blue
    #   - Then, check if the piece has any available moves
    #   - return false if any of above is not correct
    # Second Input:
    #   - First, check if the input is a valid position
    #   - Then, check if the position is in the moves list
    #   - return false if any of above is false

    if input.length == 2
      if ('a'..'h').include?(input[0]) && (1..8).include?(input[1].to_i)
        return true
      end
    end

    return false
  end

  def second_input(piece, prompt)
    puts prompt

    loop do
      input = gets.chomp
      move = validate_second_input(piece, input)
      #return input if validate_second_input(piece, input)
      return move if move != false
    end

  end

  def validate_second_input(piece, input)
    return false if validate_input(input) == false
    input = convert_board_to_arrays(input)
    #return true if piece.possible_moves.map { |move| move.new_position }.include?(input)
    piece.possible_moves.each { |move| return move if move.new_position == input }

    false
  end

  def get_promotion_piece
    puts "Select a piece to promote to"
    puts "  1 - Queen"
    puts "  2 - Rook"
    puts "  3 - Bishop"
    puts "  4 - Knight"
    loop do
      conversion = { '1' => Queen, '2' => Rook, '3' => Bishop, '4' => Knight }
      input = gets.chomp
      if (1..4).map { |n| n.to_s }.include?(input)
        return conversion[input]
      end
    end

  end
end
