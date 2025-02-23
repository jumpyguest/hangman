class Game
  STICK = [[""],
           ["  _______", "	|", "	|", "	|", "	|", "	|", "	|", "\n"],
           ["  _______", "	|", "  O\t|", "	|", "	|", "	|", "	|", "\n"],
           ["  _______", "	|", "  O\t|", "  |	|", "  |	|", "	|", "	|", "\n"],
           ["  _______", "	|", "  O\t|", " /|\t|", "  |	|", "	|", "	|", "\n"],
           ["  _______", "	|", "  O\t|", " /|\\\t|", "  |	|", "	|", "	|", "\n"],
           ["  _______", "	|", "  O\t|", " /|\\\t|", "  |	|", "   \\\t|", "	|", "\n"],
           ["  _______", "	|", "  O\t|", " /|\\\t|", "  |	|", " / \\\t|", "	|", "\n"],
           ["  _______", "  |\t|", "  O\t|", " /|\\\t|", "  |\t|", " / \\\t|", "	|", "\n"]]

  def initialize
    @hangman_array = Array.new
  end

  def display_hangman(count)
    puts STICK[count]
  end

  def display_word(word, array_guesses)
    word_array = word.split('')
    @hangman_array = []
    word_array.each_with_index do |value, index|
      char = array_guesses.include?(word_array[index]) ? "#{word_array[index]}" : "_"
      @hangman_array.push(char)
    end
    puts @hangman_array.join(' ')
    puts
  end

  def show_display(host)
    display_hangman(host.num_guesses)
    display_word(host.word, host.array_guesses)
    puts "Used letters: " + host.array_guesses.join(" ")
  end

  def start_game
    host = Host.new
    host.get_secret_word

    loop do
      host.prompt_guess
      host.check_guess
      show_display(host)
      if host.player_wins?(@hangman_array)
        puts "Player wins!!"
        return
      end
      break if host.num_guesses == Host::MAX_GUESSES
    end
    puts "You lost!!"
  end
end
