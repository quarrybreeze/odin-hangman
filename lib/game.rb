require_relative "word"

class Game
  
  def initialize
    @word = Word.new
    @wrong_letters = []
    @letters_guessed = []
    @lives = 6
    @playing = true
    if File.exist?("savedgame.txt")
      puts "Type new to start new game. Type load to load old save"
      input = gets.chomp.downcase
      if (input == "load")
        self.load_game
        self.play_game
      else
        self.play_game
      end
    else
      self.play_game
    end
  end

  def play_game
    until @playing == false do
      self.display_stats
      self.out_of_lives?
      self.winner?
      self.save_game
      self.user_guess
      puts "------------------------"
    end
  end

  def save_game
    puts "Do you want to save and exit the game? Y/n"
    input = gets.chomp.downcase.chr
    if (input == "y")
      File.open("savedgame.txt","w+") do |line|
        line.write("#{@word.word}")             #line 1
        line.write("\n#{@word.masked_word}")    #line 2
        line.write("\n#{@wrong_letters.join("")}")       #line 3
        line.write("\n#{@letters_guessed.join("")}")     #line 4
        line.write("\n#{@lives}")               #line 5
      end
      exit
    elsif (input == "n")
    else 
      puts "Invalid input. Please try again"
      self.save_game
    end 
  end

  def load_game
    puts "Loading save file..."
    File.open("savedgame.txt","r") do |line|
        # firstline = line.readline()
        # puts firstline
      @word.word = line.readline().chomp
      @word.masked_word = line.readline().chomp
      @wrong_letters = line.readline().chomp.split("")
      @letters_guessed = line.readline().split("")
      @lives = line.readline().chomp.to_i
    end
  end

  def out_of_lives?
    if (@lives == 0)
      @playing = false
      puts "Game over, you lose"
      puts "The word was #{@word.word}."
      if File.exist?("savedgame.txt")
        File.delete("savedgame.txt")
      end
      exit
    else
      @playing = true
    end
  end

  def winner?
    if (@word.masked_word.include?("_") == false)
      puts "You win!"
      if File.exist?("savedgame.txt")
        File.delete("savedgame.txt")
      end
      exit
    end
  end

  def display_stats
    puts "Number of lives left: #{@lives}"
    if (@wrong_letters.length > 0)
      puts "Wrong letters: #{@wrong_letters.join(" ")}"
    end
    p @word.masked_word
  end

  def user_guess
    puts "Guess a letter"
    input = gets.chomp.downcase.chr
    if @letters_guessed.include?(input) 
      puts "Already guessed #{input}. Try again!"
      user_guess
    else
      if check_guess(input)
        puts "#{input} is correct!"
        right_letter(input)
      else 
        puts "Oops. #{input} is wrong!"
        @lives -= 1
        wrong_letter(input)
      end
    end
  end

  def check_guess(letter)
    @word.word.include?(letter)
  end

  def right_letter(guessed_letter)
    @letters_guessed.push(guessed_letter)
    word_array = @word.word.split('')
    mask_array = @word.masked_word.split(' ')

    word_array.each_with_index do |letter, index|
      if letter == guessed_letter
        mask_array[index] = letter
      end
    end
    @word.masked_word = mask_array.join(" ")
  end

  def wrong_letter(guessed_letter)
    @wrong_letters.push(guessed_letter)
    @letters_guessed.push(guessed_letter)
  end

end