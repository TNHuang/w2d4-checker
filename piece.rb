class Piece
  attr_accessor :color, :board, :pos

  def initialize(color, board, pos)

    @color, @board, @pos = color, board, pos
    board.add_piece(self, pos)
  end

  def render
    symbols[color]
  end

  def symbols
    raise NotImplementedError
  end


end