# Stores the pegs
class Board
  def initialize
    @turns = Array.new(12, { code_pegs: Array.new(4, ''), key_pegs: Array.new(4, '') })
    @guesses = Array.new(4, '')
    @code = Array.new(4, '')
  end
end
