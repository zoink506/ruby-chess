require_relative './Game.rb'

game = Game.new([
  ['Rr', '0', '0', '0', 'Kr', '0', '0', 'Rr'],
  ['0', '0', '0', '0', '0', '0', '0', '0'],
  ['0', '0', '0', '0', '0', '0', '0', '0'],
  ['0', '0', '0', '0', '0', '0', '0', '0'],
  ['0', '0', '0', '0', '0', '0', '0', '0'],
  ['0', '0', '0', '0', '0', '0', '0', '0'],
  ['0', '0', '0', '0', '0', '0', '0', '0'],
  ['Rb', '0', '0', '0', 'Kb', '0', '0', 'Rb'],
])
#game = Game.new
game.play
