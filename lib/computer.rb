
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
