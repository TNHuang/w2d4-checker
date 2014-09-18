class Pieces
  attr_accessor :color, :name

  def initialize(color)
    @color = color
    @name = (color == :b ? "♟" : "♙")
  end

end