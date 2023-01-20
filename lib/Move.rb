class Move
  attr_accessor :original_position, :new_position

  def initialize(from, to, piece)
    @original_position = from
    @new_position = to
    @piece = piece
  end
end
