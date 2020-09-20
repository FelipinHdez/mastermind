require_relative 'key_pegs'

# Handles the computer logic
class ComputerPlayer
  attr_accessor :name

  include Key_pegs

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
    if turn.zero?
      restart_possible_guesses
      guess = rand_code
      @possible_guesses.delete_at(code_to_base6(guess))
      result = guess
    else
      last_guess, guess_keys = @board.turns[TURNS - turn].values
      last_guess = last_guess.clone
      guess_keys = guess_keys.clone.sort
      update_possible_guesses(last_guess, guess_keys)
      result = base6_to_code(@possible_guesses.sample.to_s(6).to_i)
    end
    sleep 0.1
    result
  end

  def switch_roles?
    true
  end

  private

  def rand_code
    Array.new(4) { rand(1..6) }
  end

  def code_to_base6(code)
    code.reduce(0){ |a, i| a * 10 + (i - 1) }
  end

  def base6_to_code(code)
    code = '0000' << code.to_s
    code.chars.last(4).map{ |i| i.to_i + 1 }
  end

  def update_possible_guesses(new_guess, new_keys)
    @possible_guesses.filter! do |code| 
      code = base6_to_code(code.to_s(6).to_i)
      calc_key_pegs(new_guess.clone, code.clone).sort == new_keys
    end
  end

  def restart_possible_guesses
    @possible_guesses = [*0..1295]
  end
end
