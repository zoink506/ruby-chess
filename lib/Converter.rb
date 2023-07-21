module Converter
  # responsibilities:
  #   - convert user-friendly board positions to program-friendly array values

  def convert_board_to_arrays(board_pos)
    # 'c3' = [2,3]

    arr = []
    columns = {
      'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7
    }
    rows = {
      8 => 0, 7 => 1, 6 => 2, 5 => 3, 4 => 4, 3 => 5, 2 => 6, 1 => 7
    }

    arr << rows[ board_pos[1].to_i ]
    arr << columns[ board_pos[0] ]
    arr

  end

  def convert_arrays_to_board(array_pos)
    # [2,3] = 'c3'

    str = ''
    columns = {
      0 => 'a', 1 => 'b', 2 => 'c', 3 => 'd', 4 => 'e', 5 => 'f', 6 => 'g', 7 => 'h'
    }
    rows = {
      0 => 8, 1 => 7, 2 => 6, 3 => 5, 4 => 4, 5 => 3, 6 => 2, 7 => 1
    }

    str += columns[array_pos[1]]
    str += rows[array_pos[0]].to_s
    str
  end

  def convert_column_to_letter(column)
    conversion_hash = {
      0 => 'a', 1 => 'b', 2 => 'c', 3 => 'd', 4 => 'e', 5 => 'f', 6 => 'g', 7 => 'h'
    }
    conversion_hash[column]
  end
end