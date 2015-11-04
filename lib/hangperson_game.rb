class HangpersonGame

  LETTER_PLACEHOLDER = '-'
  MAX_GUESSES = 7

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses
  attr_reader :word_with_guesses
  # Get a word from remote "random word" service

  def initialize(word)
    start_new_game(word)
  end

  public
  def guess(letter)
    raise ArgumentError, "Argument is not a letter" unless letter =~ /[a-zA-Z]/ 
    raise RuntimeError, "Game has already ended" unless check_win_or_lose == :play
    
    guess = letter.downcase

    return false unless is_new_guess?(guess)
    
    if is_correct_guess?(guess)
      register_correct_guess(guess)
      update_word_with_guesses
    else
      register_wrong_guess(guess)
    end
    return true
  end
  
  def check_win_or_lose
    if reached_max_guesses?
      :lose
    elsif guessed_complete_word?
      :win
    else
      :play
    end
  end
  
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  private
  def start_new_game(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @wrong_guess_count = 0
    
    update_word_with_guesses
  end
  
  def is_new_guess?(guess)
    !@guesses.include?(guess) && !@wrong_guesses.include?(guess)
  end
  
  def is_correct_guess?(guess)
    @word.downcase.include?(guess)
  end

  def register_correct_guess(guess)
    return if @guesses.include?(guess)
    @guesses << guess
  end
  
  def update_word_with_guesses
    @word_with_guesses = ''
    @word.each_char do |letter|
      if @guesses.include?(letter)
        @word_with_guesses << letter
      else
        @word_with_guesses << LETTER_PLACEHOLDER
      end
    end
  end

  def register_wrong_guess(guess)
    return if @wrong_guesses.include?(guess)
    @wrong_guesses << guess
    @wrong_guess_count = @wrong_guess_count + 1
  end
  
  def guessed_complete_word?
    !reached_max_guesses? && !@word_with_guesses.include?(LETTER_PLACEHOLDER)
  end
  
  def reached_max_guesses?
    @wrong_guess_count >= MAX_GUESSES
  end
    
end
