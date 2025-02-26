require 'json'

class Game
  attr_accessor :host, :hangman_array

  STICK = [[''],
           ['  _______', "\t|", "\t|", "\t|", "\t|", "\t|", "\t|", "\n"],
           ['  _______', "\t|", "  O\t|", "\t|", "\t|", "\t|", "\t|", "\n"],
           ['  _______', "\t|", "  O\t|", "  |\t|", "  |\t|", "\t|", "\t|", "\n"],
           ['  _______', "\t|", "  O\t|", " /|\t|", "  |\t|", "\t|", "\t|", "\n"],
           ['  _______', "\t|", "  O\t|", " /|\\\t|", "  |\t|", "\t|", "\t|", "\n"],
           ['  _______', "\t|", "  O\t|", " /|\\\t|", "  |\t|", "   \\\t|", "\t|", "\n"],
           ['  _______', "\t|", "  O\t|", " /|\\\t|", "  |\t|", " / \\\t|", "\t|", "\n"],
           ['  _______', "  |\t|", "  O\t|", " /|\\\t|", "  |\t|", " / \\\t|", "\t|", "\n"]]

  def initialize(host, hangman_array)
    @host = host
    @hangman_array = hangman_array
  end

  def to_json(*_args)
    JSON.dump({
                host: @host,
                hangman_array: @hangman_array
              })
  end

  def self.from_json(string)
    puts 'game from json'

    data = JSON.load string

    # Two ways to deserialize Host object:
    # (1) call Host.from_json and pass Hash.to_json as argument.
    # Note: data['host'] is an instance of Hash.
    host_json = Host.from_json(data['host'].to_json)

    # (2) create a Host object and assign each instance variable
    # hash = data['host']
    # host_json = Host.new(0, '', '', [])
    # host_json.num_guesses = hash["num_guesses"]
    # host_json.guess = hash["guess"]
    # host_json.word = hash["word"]
    # host_json.array_guesses = hash["array_guesses"]

    new(host_json, data['hangman_array'])
  end

  def display_hangman(count)
    puts STICK[count]
  end

  def display_word(word, array_guesses)
    word_array = word.split('')
    @hangman_array = []
    word_array.each_with_index do |_value, index|
      char = array_guesses.include?(word_array[index]) ? "#{word_array[index]}" : '_'
      @hangman_array.push(char)
    end
    puts @hangman_array.join(' ') + "\n\n"
  end

  def show_display
    display_hangman(@host.num_guesses)
    display_word(@host.word, @host.array_guesses)
    puts 'Used letters: ' + @host.array_guesses.join(' ')
  end

  def play_game
    @host.get_secret_word if @host.word == ''

    show_display
    loop do
      @host.prompt_guess
      if @host.guess == '1'
        puts 'Exit game...'
        return
      elsif @host.guess == '2'
        puts 'Save and exit game...'
        save_game
        return
      else
        @host.check_guess
      end

      show_display
      if @host.player_wins?(@hangman_array)
        puts 'Player wins!!'
        return
      end
      break if @host.num_guesses == Host::MAX_GUESSES
    end
    puts "The word is: #{@host.word}"
    puts 'You lost!!'
  end

  def save_game
    File.open('hangman.json', 'w') { |file| file.puts(to_json) }
    puts 'saved to hangman.json'
  end
end
