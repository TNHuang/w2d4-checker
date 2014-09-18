#!/usr/bin/env ruby

require_relative 'checker_board'

class Game
  attr_accessor :board, :turn, :is_won

  def initialize
    @board = Board.new
    @turn = [:black,:white].cycle
    @is_won = false
  end

  def play

    until self.is_won
      p is_won
      current_turn = turn.next


      puts "It's #{current_turn} player\'s turn"
      board.render
      make_move(current_turn)
      break if board.grid.flatten.compact.count == 1
    end

    puts "#{current_turn} player won!"
  end

  def get_move
    puts "please enter the start and end position:"
    input = gets.chomp

    matches = input.scan(/\d/).to_a.map(&:to_i)
    move_sequence = []

    start_pos = [matches.shift, matches.shift]
    move_sequence << [matches.shift, matches.shift] until matches.length < 2
    [start_pos, move_sequence]
  end

  def make_move(current_color)
    begin
      start_pos, move_sequence = get_move

      pos_color = board[start_pos].color

      raise if pos_color != current_color

    rescue
       puts "it's not your turn yet!"
       retry
    end

    p board.all_enemy_moves_empty?(current_color)
    p board.all_enemy_pieces(current_color).count
    p board.all_my_pieces(current_color).count
    p board.grid.flatten.compact.count

    board.perform_moves(start_pos, move_sequence) unless move_sequence.empty?
    if board.grid.flatten.compact.count == 1 || board.all_enemy_moves_empty?(current_color) || board.all_enemy_pieces(current_color).empty?
      is_won = true

    end
  end


end


#
# if __FILE__ == $PROGRAM_NAME
#   g = Game.new(9)
#   g.play
# end