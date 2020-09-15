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

TURNS = 12

# Stores the pegs
class Board
  attr_accessor :turns, :code

  def initialize
    make_new_board
  end

  def make_new_board
    @turns = Array.new(TURNS, { code_guess: Array.new(4, 0), key_pegs: Array.new(4, 0) })
    @code = Array.new(4, 0)
  end

  def print_board(show_code = false, highlighted = -1)
    print_line(@code, show_code, highlighted.zero?)
    print("------------|\n")
    @turns.each_with_index do |line, i|
      print_line(line, true, highlighted == (i + 1))
    end
  end

  private

  def print_line(line, show, highlighted)
    if line.is_a?(Array)
      print_secret_code(line, show, highlighted)
    else
      print_code_guess(line[:code_guess], highlighted)
      print('|')
      print_key_pegs(line[:key_pegs], highlighted)
    end
    print("\n")
  end

  def print_secret_code(code, show, highlighted)
    to_print = ''
    if show
      code.each { |peg| to_print << " #{peg} " }
    else
      code.each { to_print << ' ? ' }
    end
    to_print << '|'
    to_print = to_print.bg_green.bold.black if highlighted
    print(to_print)
  end

  def print_code_guess(pegs, highlighted)
    colors = %i[red green brown blue magenta cyan]
    to_print = ''
    pegs.each do |peg|
      peg = if peg.zero?
              '_'
            else
              peg.to_s.send(colors[peg - 1])
            end
      to_print << " #{peg} "
    end
    to_print = to_print.bg_green.bold.black if highlighted
    print(to_print)
  end

  def print_key_pegs(pegs, highlighted)
    colors = %i[green red]
    to_print = ''
    pegs.each do |peg|
      peg = if peg.zero?
              ' '
            else
              '•'.to_s.send(colors[peg - 1])
            end
      to_print << " #{peg}"
    end
    to_print = to_print.bg_green.bold.black if highlighted
    print(to_print)
  end
end

# Handles game logic
class Game
  def initialize
    @board = Board.new
    @players = [HumanPlayer.new, ComputerPlayer.new]
  end

  def play
    codemaker = 1
    codebreaker = 0
    loop do
      @board.code = player[codemaker].get_code
      @board.print_board
      turn = 0
      while turn < TURNS
        code_guess = player[codebreaker].get_guess
        @board.turns[turn][:code_guess] = code_guess
        key_pegs = get_key_pegs(code_guess, @board.code)
        @board.turns[turn][:key_pegs] = key_pegs
        @board.print_board
        if key_pegs == [1,1,1,1]
          puts "Player #{player[codebreaker].name} guessed #{player[codemaker].name}'s code in #{turn} turns!\n#{'#{player[codebreaker].name} won!!'.green.bold.bg_black}"
          # TODO: decide the next codemaker and codebreaker
          break
        end
        turn += 1
      end
    end
  end

  private

  def get_key_pegs(code_guess, code)
    key_pegs = code_guess.each_with_index.map do |guess_peg, i|
      guess_peg == code[i] ? 1 : 0
    end
    key_pegs.reverse_each.with_index do |item, i| 
      i = key_pegs.lenght - (i + 1)
      code.delete_at(i) if item == 1
    end
    key_pegs.map! do |item|
      return 1 if item == 1

      if code.include? item
        code.delete_at(code.index(item) || code.length)
        return 2
      end
      # TODO: delete line below after testing
      print "#{item} : this should never happen\n" if item != 0 
      return item
    end
    return key_pegs
  end
end

# TODO: implement .name and .get_guess
# Handles the computer logic
class ComputerPlayer
end

# TODO: implement .name and .get_guess
# Handles user input
class HumanPlayer
end

test = Board.new
test.print_board
