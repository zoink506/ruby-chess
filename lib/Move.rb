class Move
  attr_accessor :original_position, :new_position, :piece, :type, :promoted_to, :piece_taken

  def initialize(from, to, piece, type = "Regular", piece_taken = nil, promoted_to = nil)
    @original_position = from   # the square that the moving piece came from
    @new_position = to          # the square that the moving piece moved to
    @piece = piece              # the piece object itself
    @type = type                # type of move
    @promoted_to = promoted_to  # sumn
    @piece_taken = piece_taken
  end
end
