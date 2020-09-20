require_relative 'key_pegs'

# Handles game logic
class Game
  include Key_pegs

  def initialize
    @board = Board.new
    @players = [HumanPlayer.new(@board), ComputerPlayer.new(@board)]
    @turn = 0
    @codemaker = 1
    @codebreaker = 0
  end

  def play
    loop do
      @board.code = @players[@codemaker].make_code
      @board.print_board
      while @turn < TURNS
        board_row = TURNS - (@turn + 1)
        code_guess = @players[@codebreaker].make_guess(@turn)
        @board.turns[board_row][:code_guess] = code_guess
        key_pegs = calc_key_pegs(code_guess.clone, @board.code.clone).shuffle
        @board.turns[board_row][:key_pegs] = key_pegs
        @board.print_board
        if key_pegs == [1, 1, 1, 1] || @turn + 1 == TURNS
          game_over
          break
        end
        @turn+= 1
      end
    end
  end

  private

  def game_over
    if @turn + 1 == TURNS
      winner = @codemaker
      loser = @codebreaker
    else
      winner = @codebreaker
      loser = @codemaker
    end
    @board.print_board(show_code: true)
    @board.make_new_board
    if winner == @codebreaker
      puts "#{@players[winner].name.capitalize} guessed #{@players[loser].name}'s code in #{@turn + 1} turns!".green.bold.bg_black
    else
      puts "#{@players[loser].name.capitalize} couldn't guess #{@players[winner].name}'s code after #{@turn + 1} turns".green.bold.bg_black
    end
    puts "#{@players[winner].name.capitalize} won!!".green.bold.bg_black
    sleep 1
    @codebreaker, @codemaker = @codemaker, @codebreaker if @players.map(&:switch_roles?).all?
    @board.make_new_board
    @turn = 0
  end
end
