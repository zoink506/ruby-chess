module Converter
  def convert_board_to_arrays(board_pos)
    # Input: [2,3], Output: 'c3'

    str = ''
    conversion_hash = {
      0 => 'a', 1 => 'b', 2 => 'c', 3 => 'd', 4 => 'e', 5 => 'f', 6 => 'g', 7 => 'h'
    }

    str += conversion_hash[board_pos[1]]
    str += board_pos[0].to_s
    str
  end

  def convert_arrays_to_board(array_pos)

  end

  def convert_column_to_letter(column)
    conversion_hash = {
      0 => 'a', 1 => 'b', 2 => 'c', 3 => 'd', 4 => 'e', 5 => 'f', 6 => 'g', 7 => 'h'
    }
    conversion_hash[column]
  end
end