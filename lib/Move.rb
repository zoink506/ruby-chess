class Move
  attr_accessor :original_position, :new_position, :piece, :type, :promoted_to

  def initialize(from, to, piece, type = "Regular", promoted_to = nil)
    @original_position = from
    @new_position = to
    @piece = piece
    @type = type
    @promoted_to = promoted_to
  end
end
