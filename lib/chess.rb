require_relative './Game.rb'

game = Game.new([
  ['Kr' , '0', '0', '0' , '0' , '0', '0', '0' ],
  ['0', '0', '0', '0' , '0' , '0' , '0', '0' ],
  ['0' , '0', '0', '0' , '0' , '0' ,'pb', '0' ],
  ['0' , '0', '0', '0' , '0' , '0' , '0', '0' ],
  ['0' , '0', '0', '0' , '0' , 'pr', '0', '0' ],
  ['0' , '0', '0', '0' , '0' , '0' , '0', '0' ],
  ['0' , '0', '0', '0' , '0' , '0' , 'pb', '0' ],
  ['Kb' , '0', '0', '0' , '0' , '0' , '0', '0'],
])
#game = Game.new
game.play


# TODO LIST
#   - refactor all methods into smaller methods to follow DRY and SOLID principles
#   - Create undo_move(move) method to eliminate board duplication (duplicating board to find possible moves which is very slow and memory intensive)
#   - 