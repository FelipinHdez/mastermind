module Key_pegs
  def calc_key_pegs(code_guess, code)
    code_guess = code_guess.clone
    code = code.clone
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