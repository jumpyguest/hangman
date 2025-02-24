require_relative 'lib/game'
require_relative 'lib/host'

game = Game.new(Host.new(0, '', '', Array.new), Array.new)

puts "Welcome to *** H A N G M A N! ***\n"
puts "[1] New Game"
puts "[2] Load Game"
choice = ''
loop do
  choice = $stdin.getch
  break if choice == '1' || choice == '2'
end
if choice == '2'
  if File.exist?('hangman.json')
    puts "Loading saved game..."
    game = Game.from_json(File.read('hangman.json'))
  else
    puts "Saved game not found. Starting a new game..."
  end
end
game.play_game