# Stores the pegs
class Board
  attr_accessor :turns, :code

  @@instructions = ['',"◦ = wrong guess
#{'•'.gray} = correct color, wrong position
#{'•'.green} = correct color, correct position
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
    to_print = color_line('x', '◦', '•', pegs, %i[green gray]).rstrip
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
