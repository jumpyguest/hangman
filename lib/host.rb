require 'io/console'

class Host
  attr_reader :num_guesses, :guess, :word, :array_guesses

  MAX_GUESSES = 8

  def initialize(num_guesses, guess, word, array_guesses)
    @num_guesses = num_guesses
    @guess = guess
    @word = word
    @array_guesses = array_guesses
  end

  def get_secret_word
    file = File.open('google-10000-english-no-swears.txt')
    loop do
      line = rand(1..9894)
      file.rewind
      line.times do
        @word = file.gets.chomp
      end
      break if @word.length >= 5 && @word.length <= 12
    end
    file.close
    puts 'Secret word has been generated!'
  end

  def prompt_guess
    loop do
      puts 'Enter a letter, or [1] - Exit | [2] - Save and Exit: '
      @guess = $stdin.getch.downcase
      if @array_guesses.include?(@guess)
        next
      elsif (@guess >= 'a' && @guess <= 'z') || @guess == '1' || @guess == '2'
        break
      end
    end
    puts "You entered '#{@guess}'"
  end

  def check_guess
    @num_guesses += 1 unless @word.include?(@guess)
    @array_guesses.push(@guess)
  end

  def player_wins?(hangman_array)
    return unless hangman_array.join == @word

    true
  end

  def to_json(_options = {})
    JSON.dump({
                num_guesses: @num_guesses,
                guess: @guess,
                word: @word,
                array_guesses: @array_guesses
              })
  end

  def self.from_json(string)
    data = JSON.load string
    new(data['num_guesses'], data['guess'], data['word'], data['array_guesses'])
  end
end
