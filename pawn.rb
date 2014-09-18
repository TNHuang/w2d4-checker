require_relative 'piece'

class Pawn < Piece
  def symbols
    { white: '♙', black: '♟' }
  end
end