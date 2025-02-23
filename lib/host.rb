require 'io/console'

class Host
  attr_reader :num_guesses, :word, :array_guesses

  MAX_GUESSES = 8

  def initialize
    @num_guesses = 0
    @guess = ''
    @word = ''
    @array_guesses = Array.new
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
    puts "Secret word has been generated!"
    p @word
  end

  def prompt_guess
    loop do
      puts "Enter a letter: "
      @guess = $stdin.getch.downcase
      if @array_guesses.include?(@guess)
        next
      elsif @guess >= 'a' && @guess <= 'z'
        break
      end
    end
    puts "You entered '#{@guess}'"
  end

  def check_guess
    if !@word.include?(@guess)
      @num_guesses += 1
    end
    @array_guesses.push(@guess)
  end

  def player_wins?(hangman_array)
    if hangman_array.join == @word
      return true
    end
  end
end