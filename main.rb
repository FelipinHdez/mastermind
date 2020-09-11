# Stores the pegs
class Board
  attr_accessor :turns, :guesses, :code
  def initialize
    make_new_board
  end

  def make_new_board
    @turns = Array.new(12, { code_pegs: Array.new(4, 0), key_pegs: Array.new(4, 0) })
    @code = Array.new(4, 0)
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
