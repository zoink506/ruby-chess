class Move
  attr_accessor :original_position, :new_position, :piece, :type

  def initialize(from, to, piece, type = "Regular")
    @original_position = from
    @new_position = to
    @piece = piece
    @type = type
  end
end
