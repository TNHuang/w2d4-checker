#!/usr/bin/env ruby
# coding: utf-8

require_relative 'piece'

class Board
  attr_reader :grid, :board_size

  def initialize(board_size = 8)
    @board_size = board_size
    grid_initialize
    populate_board

  end

  def [](pos)
    y, x = pos
    @grid[y][x]
  end

  def []=(pos, value)

    y, x = pos
    @grid[y][x] = value
  end

  def out_of_bound?(pos)
    pos.any? {|dim| !dim.between?(0, board_size-1)}
  end

  def empty?(pos)
    self[pos].nil?
  end

  def move(start_pos, end_pos)
    unless self[start_pos].nil?

      self[start_pos].move(end_pos)
    else
      puts "starting square have no piece"
    end
  end

  def perform_moves(start_pos, move_sequence)
    unless self[start_pos].nil?

      self[start_pos].perform_moves(move_sequence)
    else
      puts "starting square have no piece"
    end
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def render
    board_edge = Array.new(board_size + 1, "+").join('---')
    board_edge_letters = (0..board_size - 1).to_a.join('   ')
    board_edge_letters = "    #{board_edge_letters}"

    puts board_edge_letters
    puts  "  #{board_edge} "
    grid.each_with_index do |row, i|
      row = row.map.with_index do |ele, j|
        ele.nil? ? " " : ele.render

      end.join(' | ')

      puts "#{i} | #{row} | #{i}"
      puts  "  #{board_edge} "
    end
    puts board_edge_letters
  end

  def dup
    new_board = Board.new
    pieces = self.grid.flatten.compact
    pieces.each do |piece|
      Piece.new(piece.color, new_board, piece.pos.dup)
    end
    board_size.times do |y|
      board_size.times do |x|
        if !new_board[[y,x]].nil?
          new_board[[y,x]].promote
        end
      end
    end

    new_board
  end

  def all_enemy_pieces(color)
    grid.flatten.compact.select { |piece| piece.color != color }
  end

  def all_my_pieces(color)
    grid.flatten.compact.select { |piece| piece.color == color }
  end


  def all_enemy_moves(color)
    all_move = all_enemy_pieces(color).map { |piece| piece.all_possible_moves }
  end

  def all_enemy_moves_empty?(color)
    all_enemy_moves(color).empty?
  end

  protected

  def populate_board
    fill_rows(:black)
    fill_rows(:white)
    # Piece.new(:white, self, [6,6])
    # Piece.new(:black, self, [7,7])
    # self[[7,7]].is_king = true
  end

  def fill_rows(color)
    row_indexs = (color == :white) ? [0, 1] : [board_size - 2, board_size - 1]

    row_indexs.each do |row_index|
      board_size.times do |col_index|
        Piece.new(color, self, [row_index,col_index]) if row_index.even? && col_index.even?
        Piece.new(color, self, [row_index,col_index]) if row_index.odd? && col_index.odd?
      end
    end

  end

  def grid_initialize
     @grid = Array.new(board_size) { Array.new(board_size) }
  end

end


if __FILE__ == $PROGRAM_NAME
#   b = Board.new(8)
#
#   # b.render
#
#
# good = [[2,2], [4,0], [6,2], [2,6]]
# bad = [[2,2], [4,0], [5,1]]
# puts "good sequence"
#
# b[[0,0]].valid_move_seq?(good)
#
#
# puts "bad sequence"
# bad
# puts b[[0,0]].valid_move_seq?(bad)
#
# puts "actually moving"
# b.perform_moves([0,0],good)
#
# b.render
# Piece.new(:white, self, [5, 5])
# Piece.new(:white, self, [5, 3])
# Piece.new(:black, self, [7, 0])
#
# Piece.new(:white, self, [3, 1])
# Piece.new(:white, self, [5, 1])
#
# self[[6,2]] = nil
#
# self[[0, 0]] = self[[7, 0]]
# self[[0, 0]].pos = [0, 0]
# self[[7, 0]] = nil
# self[[0, 0]].promote
end

  # puts "can only move diagonal not forward"
#
#   puts "from 6,6 to 5,6 forward => invalid "
#   p b[[6,6]].valid_move?([5,6])
#   puts "from 6,6 to 5,7 diagonal => valid"
#   p b[[6,6]].valid_move?([5,7])
#
#   puts ''
#
#   puts "can jump over enemy piece but cant slide into enemy piece"
#   puts "cant slide from 6,4 to 5,3 should be invalid"
#   p b[[6,4]].valid_move?([5,3])
#
#   puts "from 6,4 to 4,2 should be okay for jump, valid"
#   p b[[6,4]].valid_move?([4,2])
#
#   puts "cannot jump over your own piece, 6,0=>4,2 invalid"
#   p b[[6,0]].valid_move?([4,2])
#
#   puts ''
#
#   puts "king can jump backward, 0,0=>2,2 valid"
#   p b[[0,0]].valid_move?([2,2])
#   b.move([0,0], [2,2])