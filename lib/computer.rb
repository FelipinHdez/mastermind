
# Handles the computer logic
class ComputerPlayer
  attr_accessor :name
  def initialize(board)
    @board = board
    @name = 'the computer'
    @possible_guesses = [*0..1295]
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

  # This is where the AGI happens
  def make_guess(turn)
    if turn == 1
      guess = code_to_base6(rand_code)
      @possible_guesses.delete_at(guess)
      guess
    else
      last_guess, guess_keys = @board.turns[TURNS - turn].values
      last_guess = code_to_base6(last_guess)
      guess_keys = guess_keys.sort
      update_possible_guesses(last_guess, guess_keys)
      @possible_guesses.sample.base6_to_code
    end
  end

  def switch_roles?
    true
  end

  private

  def rand_code
    Array.new(4) { rand(1..6) }
  end

  def code_to_base6(code)
    code = code.reduce(0){ |a, i| a * 10 + (i - 1) }
    code.to_s.to_i(6)
  end
  
  def base6_to_code(code)
    '0000' << code.to_s
    code.chars.last(4).map{ |i| i.to_i + 1 }
  end

  def update_possible_guesses(new_guess, new_keys)
    @possible_guesses.filter { |code| get_key_pegs(new_guess, code).sort == new_keys }
  end
end
