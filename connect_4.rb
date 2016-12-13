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
    @players = Hash[player_one, [player_one[0].upcase, 44], player_two, [player_two[0].upcase, 41]]
    @winner = nil
  end

  def play!
    display
    turn_cycle
  end

  private

  def check_for_errors(input, player)
    if ("A".."G").to_a.include?(input)
      store_move(input, @players[player].first, @players[player].last)
    else
      puts "Error! Input not recognized."
      turn(player)
    end
  end

  def check_for_winner
    @board.each do |column, row|
      @players.values.each do |mark|
        vertical_tracker = 0
        row.each do |space|
          vertical_tracker += 1 if space == mark
        end
        if vertical_tracker >= 4
          @winner ||= @players.key(mark)
          break
        end
        (0..5).each do |index|
          horizontal_tracker = 0
          ("A".."G").each do |column|
            horizontal_tracker += 1 if @board[column.to_sym][index] == mark
          end
          if horizontal_tracker >= 4
            @winner ||= @players.key(mark)
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
          print "[#{pretty_colors(@board[column.to_sym][row].first, @board[column.to_sym][row].last)}]"
        end
      end
      print "\n"
    end
    label = String.new
    ("A".."G").each { |letter| label.concat(" #{letter} ") }
    puts label
    print "\n"
  end

  def store_move(input, mark, color_code)
    @board[input.to_sym].reverse_each.with_index do |space, index|
      if space.nil?
        @board[input.to_sym][5 - index] = [mark, color_code]
        break
      end
    end
    display
  end

  def turn(player, color_code)
    print "#{pretty_colors(player, color_code)}'s turn: "
    input = gets.chomp.upcase
    puts "---------------------"
    check_for_errors(input, player)
    check_for_winner
  end

  def turn_cycle
    game_over = nil
    @players.keys.each do |player|
      break if game_over
      turn(player, @players[player].last)
      check_for_winner
      unless @winner.nil?
        puts "#{pretty_colors(@winner, @players[@winner].last)} wins!"
        game_over = true
      end
    end
    turn_cycle unless game_over
  end

end
