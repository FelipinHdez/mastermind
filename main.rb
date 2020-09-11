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

  def print_board(show_code = false, highlighted = nil)
    print_line(@code, show_code, highlighted == 0)
    print("---------------------\n")
    @turns.each_with_index do |line, i|
      print_line(line, true, highlighted == (i + 1))
    end
  end

  private

  def print_line(line, show, highlighted)
    if line.is_a?(Array)
      if show
        line.each{ |peg| print(" #{peg} ") }
      else
        line.each{ print(" ? ") }
      end
      print("\n")
    else
      line[:code_pegs].each{ |peg| print(" #{peg} ") }
      print("|")
      line[:key_pegs].each{ |peg| print(" #{peg}") }
      print("\n")
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
