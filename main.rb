require 'io/console'
require_relative 'lib/style'
require_relative 'lib/board'
require_relative 'lib/game'
require_relative 'lib/human'
require_relative 'lib/computer'

TURNS = 3

test = Game.new
test.play
