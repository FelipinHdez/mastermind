
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
