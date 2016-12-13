require 'pry'
require_relative 'player'

class Connect4

  attr_accessor :board, :winner
  attr_reader :players

  def initialize(player_one, player_two)
    @board =
      Hash[
        A: Array.new(6),
        B: Array.new(6),
        C: Array.new(6),
        D: Array.new(6),
        E: Array.new(6),
        F: Array.new(6),
        G: Array.new(6)
      ]
    @players = Hash[player_one, Player.new(player_one, :blue), player_two, Player.new(player_two, :red)]
    @winner = nil
  end

  def play!
    display
    turn_cycle
  end

  private

  def check_for_errors(input, player)
    if ("A".."G").to_a.include?(input)
      store_move(input, player)
    else
      puts "Error! Input not recognized."
      turn(player)
    end
  end

  def check_for_winner
    @board.each do |column, row|
      @players.values.each do |player|
        vertical_tracker = 0
        row.each do |space|
          vertical_tracker += 1 if space == player
        end
        if vertical_tracker >= 4
          @winner ||= player
          break
        end
        (0..5).each do |index|
          horizontal_tracker = 0
          ("A".."G").each do |column|
            horizontal_tracker += 1 if @board[column.to_sym][index] == player
          end
          if horizontal_tracker >= 4
            @winner ||= player
            break
          end
        end
      end
    end
  end

  def pretty_colors(mark, color_code)
    "\e[#{color_code}m#{mark}\e[0m"
  end

  def display
    (0..5).each do |row|
      ("A".."G").each do |column|
        if @board[column.to_sym][row].nil?
          print "[ ]"
        else
          print "[#{@board[column.to_sym][row].pretty_mark}]"
        end
      end
      print "\n"
    end
    label = String.new
    ("A".."G").each { |letter| label.concat(" #{letter} ") }
    puts label
    print "\n"
  end

  def store_move(input, player)
    @board[input.to_sym].reverse_each.with_index do |space, index|
      if space.nil?
        @board[input.to_sym][5 - index] = player
        break
      end
    end
    display
  end

  def turn(player)
    print "#{player.pretty_name}'s turn: "
    input = gets.chomp.upcase
    puts "---------------------"
    check_for_errors(input, player)
    check_for_winner
  end

  def turn_cycle
    game_over = nil
    @players.values.each do |player|
      break if game_over
      turn(player)
      check_for_winner
      unless @winner.nil?
        puts "#{player.pretty_name} wins!"
        game_over = true
      end
    end
    turn_cycle unless game_over
  end

end
