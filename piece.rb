require 'debugger'

class Piece
  attr_accessor :color, :board, :pos, :is_king, :board_dir


  def initialize(color, board, pos)

    @color, @board, @pos = color, board, pos
    @is_king = false

    board.add_piece(self, pos)

    @board_dir = 4 <=> pos[0]

  end

  def move(end_pos)
    return "illegal move" unless valid_move?(end_pos)
    perform_jump(end_pos) if can_jump?(end_pos)
    perform_slide(end_pos) if can_slide?(end_pos)
    self.promote
  end

  def perform_moves(move_sequence)

    return "illegal sequence" unless valid_move_seq?(move_sequence)
    move_sequence.each do |sub_pos|
      move(sub_pos)
    end

  end

  def combo_move(move_sequence)
  end

  def valid_move?(end_pos)
    return false if board.out_of_bound?(end_pos)
    return false unless is_move_diagonal?(end_pos)
    return false unless delta.include?(dir(end_pos))
    return false unless can_jump?(end_pos) || can_slide?(end_pos)
    true
  end

  def valid_move_seq?(move_sequence)
    root_pos = pos
    f = board.dup

    if move_sequence.length == 1

      return f[root_pos].valid_move?(move_sequence[0])
    elsif move_sequence.length > 1

      move_sequence.each do |current_pos|
        current_piece = f[root_pos]

        return false if current_piece.board.out_of_bound?(current_pos)
        return false unless current_piece.is_move_diagonal?(current_pos)
        return false unless current_piece.delta.include?(current_piece.dir(current_pos))
        return false unless current_piece.can_jump?(current_pos)

        f.move(root_pos,current_pos)
        root_pos = [current_pos[0], current_pos[1]]
      end
    end

    true
  end

  def can_slide?(end_pos)
    board.empty?(end_pos) && dydx(end_pos).all? {|coord| coord.abs == 1}
  end

  def can_jump?(end_pos)
    #fix this for super jum,p
    board.empty?(end_pos) && only_one_opponent_in_path_and_all_empty?(end_pos)
  end

  def perform_slide(end_pos)
    board[end_pos], board[self.pos], self.pos = self, nil, end_pos
  end

  def perform_jump(end_pos)
    path = get_path(end_pos)
    path.each {|sub_pos| board[sub_pos] = nil}
    board[end_pos], board[self.pos], self.pos = self, nil, end_pos
  end

  def dydx(end_pos)
    [end_pos[0] - pos[0], end_pos[1]- pos[1]]
  end

  #write about super jump--------------------
  #get all path
  def get_path(end_pos)
    #all blocks between start and end position
    dy, dx = dir(end_pos)
    path = [pos]

    path << [path.last[0] + dy, path.last[1] + dx] until path.last == end_pos

    path -= [pos, end_pos]
  end

  def opponents_in_path(path)
    path.select { |sub_pos| opponent?(sub_pos) }
  end

  def path_empty?(path)
    path.all? { |sub_pos| board.empty?(sub_pos) }
  end

  def only_one_opponent_in_path_and_all_empty?(end_pos)
    path = get_path(end_pos)

    opponents = opponents_in_path(path)
    return false if opponents.length != 1

    new_path = path - opponents
    path_empty?(new_path)
  end
  #--------------------------------------------
  def is_move_diagonal?(end_pos)
    ( end_pos[0] - pos[0] ).abs == ( end_pos[1] - pos[1] ).abs
  end

  def dir(end_pos)#give it a direction
    [end_pos[0] <=> pos[0], end_pos[1] <=> pos[1]]
  end

  def opponent?(pos)
    return false if board[pos].nil? || pos == []
    board[pos].color != self.color
  end

  def promote
    #promote to king and allow back row delta
    unless is_king
      goal = (color == :white) ? 7 : 0
      if pos[0] == goal
        self.is_king = true
      end
    end

  end

  def render
    symbols[color]
  end

  def symbols
    is_king ? { white: '♔', black: '♚' } : { white: '♙', black: '♟' }
  end

  def delta
    if is_king
      [ [ 1,1], [ 1, -1], [-1,1], [-1, -1] ]
    else
      [ [board_dir,1], [board_dir, -1] ]
    end
  end

end


