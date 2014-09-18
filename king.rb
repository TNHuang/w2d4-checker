require_relative 'piece'

class King < Piece
  def symbols
    { white: '♔', black: '♚' }
  end
end