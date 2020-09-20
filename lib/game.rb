
# Handles game logic
class Game
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
        key_pegs = get_key_pegs(code_guess.clone, @board.code.clone).shuffle
        @board.turns[board_row][:key_pegs] = key_pegs
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

  def get_key_pegs(code_guess, code)
    key_pegs = code_guess.each_with_index.map do |guess_peg, i|
      guess_peg == code[i] ? 1 : 0
    end
    key_pegs.reverse_each.with_index do |item, i|
      i = key_pegs.length - (i + 1)
      if item == 1
        code.delete_at(i)
        code_guess.delete_at(i)
      end
    end
    key_pegs.each_with_index do |item, i|
      if (code.include? code_guess[i]) && (item.zero?)
        code.delete_at(code.index(code_guess[i]))
        key_pegs[i] = 2
      end
    end
    key_pegs
  end
end
