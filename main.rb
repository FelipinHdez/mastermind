require 'io/console'

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  
  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end
  
  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end

TURNS = 3

# Stores the pegs
class Board
  attr_accessor :turns, :code

  @@instructions = ['',"◦ = wrong guess
#{'•'.red} = wrong position, correct color
#{'•'.green} = correct position, correct color
(Not in order)\n"]

  def initialize
    make_new_board
  end

  def make_new_board
    @turns = Array.new(TURNS) { { code_guess: Array.new(4, 0), key_pegs: Array.new(4, 0) } }
    @code = Array.new(4, 0)
  end

  # I should have used a command line framework instead of this mess
  def print_board(
    show_code: false,
    highlighted: -1,
    print_output: true,
    instructions: 1,
    print_key_help: false,
    end_string: [0, ''])

    clear_terminal

    to_print = ''
    to_print << @@instructions[instructions]

    to_print << "  MASTERMIND  \n".red.underline
    to_print << print_line(@code, show_code, highlighted.zero?, end_string[0].zero? ? end_string[1] : '')
    to_print << "├────────────┤\n".red
    @turns.each_with_index do |line, i|
      key_help = !line[:code_guess].include?(0) && print_key_help
      to_print << print_line(line, true, highlighted == (i + 1), end_string[0] == (i + 1) ? end_string[1] : '', key_help)
    end
    if print_output
      print(to_print)
      STDOUT.flush
    else
      to_print
    end
  end

  private

  def print_line(line, show, highlighted, end_string, key_help = false)
    separator = highlighted ? '│'.red.bg_green.bold.black : '│'.red
    to_print = ''
    to_print << separator
    if line.is_a?(Array)
      to_print << print_secret_code(line, show, highlighted)
    else
      to_print << print_code_guess(line[:code_guess], highlighted)
      to_print << separator
      to_print << print_key_pegs(line[:key_pegs], false)
      to_print << print_key_help(line[:key_pegs]) if key_help
    end
    to_print << end_string << "\n"
  end

  def print_secret_code(code, show, highlighted)
    colors = %i[red green brown blue magenta cyan]
    to_print = ''
    if show
      code.each { |peg| to_print << " #{peg.to_s.send(colors[peg - 1])} " }
    else
      code.each { to_print << ' ? ' }
    end
    to_print << '│'.red
    to_print = to_print.bg_green.bold.black if highlighted
    to_print
  end

  def print_code_guess(pegs, highlighted)
    colors = %i[red green brown blue magenta cyan]
    to_print = color_line(' x ', '_', nil, pegs, colors)
    to_print = to_print.bg_green.bold.black if highlighted
    to_print
  end

  def print_key_pegs(pegs, highlighted)
    to_print = color_line('x', '◦', '•', pegs, %i[green red]).rstrip
    to_print = to_print.bg_green.bold.black if highlighted
    to_print
  end

  def color_line(margin_str, zero_str, value_str, pegs, colors)
    to_print = ''
    pegs.each do |peg|
      peg = if peg.zero?
              zero_str
            elsif value_str.nil?
              peg.to_s.send(colors[peg - 1])
            else
              value_str.to_s.send(colors[peg - 1])
            end
      to_print << margin_str.gsub('x', peg)
    end
    to_print
  end

  def print_key_help(pegs)
    help = []
    help.push "#{pegs.count(0)} incorrect" unless pegs.count(0).zero?
    help.push "#{pegs.count(1).to_s.green} with correct color and position" unless pegs.count(1).zero?
    help.push "#{pegs.count(2).to_s.red} with correct color but wrong position" unless pegs.count(2).zero?
    "   (#{help.join ', '})"
  end

  def clear_terminal()
    system("clear") || system("cls")
  end
end

# Handles game logic
class Game
  def initialize
    @board = Board.new
    @players = [HumanPlayer.new(@board), ComputerPlayer.new(@board)]
    @turn = 0
    @codemaker = 1
    @codebreaker = 0
  end

  def play
    loop do
      @board.code = @players[@codemaker].make_code
      @board.print_board
      while @turn < TURNS
        board_row = TURNS - (@turn + 1)
        code_guess = @players[@codebreaker].make_guess(@turn)
        @board.turns[board_row][:code_guess] = code_guess
        key_pegs = get_key_pegs(code_guess.clone, @board.code.clone)
        @board.turns[board_row][:key_pegs] = key_pegs
        if key_pegs == [1, 1, 1, 1] || @turn + 1 == TURNS
          game_over
          break
        end
        @turn+= 1
      end
    end
  end

  private

  def game_over
    if @turn + 1 == TURNS
      winner = @codemaker
      loser = @codebreaker
    else
      winner = @codebreaker
      loser = @codemaker
    end
    @board.print_board(show_code: true)
    @board.make_new_board
    if winner == @codebreaker
      puts "#{@players[winner].name.capitalize} guessed #{@players[loser].name}'s code in #{@turn + 1} turns!".green.bold.bg_black
    else
      puts "#{@players[loser].name.capitalize} couldn't guess #{@players[winner].name}'s code after #{@turn + 1} turns".green.bold.bg_black
    end
    puts "#{@players[winner].name.capitalize} won!!".green.bold.bg_black
    sleep 1
    @codebreaker, @codemaker = @codemaker, @codebreaker if @players.map(&:switch_roles?).all?
    @board.make_new_board
    @turn = 0
  end

  def get_key_pegs(code_guess, code)
    key_pegs = code_guess.each_with_index.map do |guess_peg, i|
      guess_peg == code[i] ? 1 : 0
    end
    key_pegs.reverse_each.with_index do |item, i|
      i = key_pegs.length - (i + 1)
      if item == 1
        code.delete_at(i)
        code_guess.delete_at(i)
      end
    end
    key_pegs.each_with_index do |item, i|
      if (code.include? code_guess[i]) && (item.zero?)
        code.delete_at(code.index(code_guess[i]))
        key_pegs[i] = 2
      end
    end
    key_pegs.shuffle
  end
end

# Handles the computer logic
class ComputerPlayer
  attr_accessor :name
  def initialize(board)
    @board = board
    @name = 'the computer'
  end

  def make_code
    message = '← MAKING RANDOM CODE'.red
    @board.print_board(end_string: [0, message], show_code: true, instructions: 0)

    duration = 4
    iteration_sleep = 0.05
    (duration/iteration_sleep).to_i.times do
      @board.code = rand_code
      @board.print_board(end_string: [0, message], show_code: true, instructions: 0)
      sleep iteration_sleep
    end

    @board.print_board(end_string: [0, message], instructions: 0)
    sleep 1.5

    rand_code
  end

  def make_guess(_turn)
    # TODO: finish
    rand_code
  end

  def switch_roles?
    true
  end

  private

  def rand_code
    Array.new(4) { rand(1..6) }
  end
end

# Handles user input
class HumanPlayer
  attr_accessor :name
  def initialize(board)
    @name = 'the human player'
    @board = board
  end

  def make_code
    message = '   ← MAKE CODE ' << '(from 1 to 6)'.red
    @board.print_board(end_string: [0, message])
    print "\e[#{TURNS + 2}A\e[2C"
    code = input_code('?')
    sleep 0.4
    code
  end

  def make_guess(turn)
    message = '   ← GUESS ' << '(from 1 to 6)'.red
    @board.print_board(end_string: [(TURNS - turn), message])
    print "\e[#{turn + 1}A\e[2C"
    guess = input_code('_')
    sleep 0.4
    guess
  end

  def switch_roles?
    print 'Do you want to switch codebreaker and codemaker roles? (yes/no)... '
    gets.rstrip.downcase.tr('0-9', '')[0] == 'y'
  end

  private

  def input_code(fill_char)
    guesses = []
    while guesses.length != 4
      input = STDIN.getch
      exit if input=="\u0018" or input=="\u0003"
      if input == "\u007F" && !guesses.length.zero?
        guesses.pop
        print "\e[3D#{fill_char}\e[1D"
      end
      input = input.to_i
      if input.between?(1, 6)
        guesses.push(input)
        print "#{color(input)}\e[2C"
      end
    end
    guesses
  end

  def color(str)
    colors = %i[red green brown blue magenta cyan]
    str.to_s.send(colors[str - 1])
  end
end

test = Game.new
test.play
