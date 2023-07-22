class Move
  attr_accessor :original_position, :new_position, :piece, :type, :promoted_to, :piece_taken

  def initialize(from, to, piece, options = {})
    # options { type: , piece_taken: , promoted_to: }
    @original_position = from             # the square that the moving piece came from
    @new_position = to                    # the square that the moving piece moved to
    @piece = piece                        # the piece object itself
    @type = options[:type]                # type of move
    @promoted_to = options[:promoted_to]  # specifies the type of piece a pawn got promoted to
    @piece_taken = options[:piece_taken]  # specifies the piece taken if the a piece was captured

    # move types:
    #   - Regular
    #   - Kingside Castle
    #   - Queenside Castle
    #   - En Passant
  end
end
