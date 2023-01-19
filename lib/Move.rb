class Move
  attr_accessor :original_position, :new_position

  def initialize(from, to)
    @original_position = from
    @new_position = to
  end
end
