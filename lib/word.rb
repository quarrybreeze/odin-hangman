class Word
  
  attr_accessor :masked_word, :word

  def initialize
    dictionary = read_file("google-10000-english-no-swears.txt")
    @word = pick_word(dictionary)
    @masked_word = mask_word(@word)
  end

  def read_file(filename)
    File.open(filename, "r") 
  end
  
  def pick_word(dictionary)
    filtered_dictionary = []
    dictionary.each_line do |line|
      if (line.chomp.length.between?(5,12) == true)
        filtered_dictionary = filtered_dictionary.push(line.chomp)
      end
    end
    random_word = filtered_dictionary.sample
  end

  def mask_word(word)
    masked_word = ""
    word.length.times do
      masked_word = masked_word + "_ "
    end
    masked_word.delete_suffix(" ")
  end

end
