#!/usr/bin/env ruby
require_relative 'header'

class Board
  attr_reader :grid, :board_size

  def initialize(board_size = 8)
    @board_size = board_size
    grid_initialize
    populate_board
  end

  def [](pos)
    i,j = pos
    @grid[i][j]
  end

  def []=(pos, value)
    raise "position is occupied!" unless empty?(pos)
    i,j = pos
    @grid[i][j] = value
  end

  def empty?(pos)
    self[pos].nil?
  end



  def render
    board_edge = Array.new(board_size+1, "+").join('---')
    board_edge_letters = (0..board_size-1).to_a.join('   ')
    board_edge_letters = "    #{board_edge_letters}"

    puts board_edge_letters
    puts  "  #{board_edge} "
    grid.each_with_index do |row, i|
      row = row.map.with_index do |ele, j|
        ele.nil? ? " " : ele.render

        #secret code to mark all the black
        # if arr.include?([i,j])
       #    ele.nil? ? "X" : "K"
       #  elsif ele.nil?
       #    " "
       #  else
       #    ele.name
       #  end
      end.join(' | ')

      puts "#{i} | #{row} | #{i}"
      puts  "  #{board_edge} "
    end
    puts board_edge_letters
  end


  protected

  def populate_board
    fill_rows(:black)
    fill_rows(:white)
  end

  def add_piece(piece, pos)
    raise "position is occupied!" unless empty?(pos)
    self[pos] = piece
  end

  def fill_rows(color)
    row_indexs = (color == :white) ? [0,1] : [board_size-2, board_size-1]

    row_indexs.each do |row_index|
      board_size.times do |col_index|
        Pawn.new(color, self, [i,j]) if row_index.even? && col_index.even?
        Pawn.new(color, self, [i,j]) if row_index.odd? && col_index.odd?
      end
    end

  end

  def grid_initialize
     @grid = Array.new(board_size) {Array.new(board_size)}
  end

end


if __FILE__ == $PROGRAM_NAME
  b = Board.new(9)
  b.render
end