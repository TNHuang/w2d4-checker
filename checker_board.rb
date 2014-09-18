#!/usr/bin/env ruby
require 'checker_pieces'
class Board
  attr_accessor :board, :board_size

  def initialize(board_size = 8)
    @board_size = board_size
    @board = Array.new(board_size) {Array.new(board_size)}
  end

  def populate_board

  end

  def render
    board_edge = Array.new(board_size+1, "+").join('---')
    board_edge_letters = (0..board_size-1).to_a.join('   ')
    board_edge_letters = "    #{board_edge_letters}"

    puts board_edge_letters
    puts  "  #{board_edge} "
    board.each_with_index do |row, i|
      row = row.map.with_index do |ele, j|
        ele.nil? ? " " : ele.name

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
end


if __FILE__ == $PROGRAM_NAME
  b = Board.new(9)
  b.render
end