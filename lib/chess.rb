require_relative './Game.rb'

#game = Game.new([
#  ['0', 'Kr', '0', '0' , '0' , 'Rr' , '0' , '0' ],
#  ['0' , '0', '0', '0' , '0' , '0' , '0' , '0' ],
#  ['0' , '0', '0', '0' , '0' , '0' , 'Br', '0' ],
#  ['0' , '0', '0', '0' , '0' , '0' , '0' , '0' ],
#  ['0' , '0', '0', '0' , '0' , '0' , '0' , '0' ],
#  ['0' , '0', '0', '0' , '0' , '0' , '0' , '0' ],
#  ['0' , '0', 'pb', 'pb' , '0', '0' , '0', '0' ],
#  ['Rb', '0', '0', '0' , 'Kb', '0' , '0' , 'Rb' ],
#])
game = Game.new
game.play


# TODO LIST
#   - refactor all methods into smaller methods to follow DRY and SOLID principles
#   - Create undo_move(move) method to eliminate board duplication (duplicating board to find possible moves which is very slow and memory intensive)
#   - 
