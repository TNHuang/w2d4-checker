#!/usr/bin/env ruby

require_relative 'checker_board'

class Game
  attr_accessor :board, :turn

  def initialize
    @board = Board.new
    @turn = [:w,:b].cycle
  end

  def play

    until won?
      current_turn = turn.next
      puts "It's #{current_turn} player\'s turn"
      board.render
      make_move(current_turn)
    end
  end

  def won?
    board.is_check_mate
  end

  def get_move
    puts "please enter the start and end position:"
    input = gets.chomp

    matches = input.scan(/\d/).to_a.map(&:to_i)
    [matches[1..2], matches[3..4]]
  end

  def make_move(current_color)
    begin
      start_pos, goal_pos = get_move
      p current_color
      p pos_color = board[start_pos].color

      raise if pos_color != current_color

    rescue
       puts "it's not your turn yet!"
       retry
    end

    step = board.move(start_pos, goal_pos)

    turn.next if step.nil?
    board.is_check_mate = step if step == true
  end


end


#
# if __FILE__ == $PROGRAM_NAME
#   g = Game.new(9)
#   g.play
# end