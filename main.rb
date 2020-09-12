class String
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  end

# Stores the pegs
class Board
  attr_accessor :turns, :guesses, :code

  TURNS = 12

  def initialize
    make_new_board
  end

  def make_new_board
    @turns = Array.new(TURNS, { code_pegs: Array.new(4, 0), key_pegs: Array.new(4, 0) })
    @code = Array.new(4, 0)
  end

  def print_board(show_code = false, highlighted = -1)
    print_line(@code, show_code, highlighted.zero?)
    print("------------|---------\n")
    @turns.each_with_index do |line, i|
      print_line(line, true, highlighted == (i + 1))
    end
  end

  private

  def print_line(line, show, highlighted)
    if line.is_a?(Array)
      if show
        line.each { |peg| print(" #{peg} ") }
      else
        line.each { print(" ? ") }
      end
      print('|')
    else
      print_code_pegs(line[:code_pegs])
      print('|')
      print_key_pegs(line[:key_pegs])
    end
    print("\n")
  end

  def print_code_pegs(pegs)
    colors = %i[red green brown blue magenta cyan]
    pegs.each do |peg|
      peg = if peg.zero?
              '_'
            else
              peg.to_s.send(colors[peg - 1])
            end
            print(" #{peg} ")
    end
  end

  def print_key_pegs(pegs)
    colors = %i[green red]
    pegs.each do |peg|
      peg = if peg.zero?
              ' '
            else
              '•'.to_s.send(colors[peg - 1])
            end
      print(" #{peg}")
    end
  end
end

# Handles game logic
class Game
  def initialize
    @board = Board.new
    @players = [HumanPlayer.new, ComputerPlayer.new]
  end
end

# Handles the computer logic
class ComputerPlayer
end

# Handles user input
class HumanPlayer
end

test = Board.new
test.print_board
