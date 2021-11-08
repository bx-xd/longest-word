require 'open-uri'

class GamesController < ApplicationController
  def new
    @alphabet = ("A".."Z").to_a
    @letters = []
    9.times do
      random = rand(26)
      @letters << @alphabet[random].capitalize
    end
    @letters
  end

  def score
    @word = params['word'].upcase
    @letters = params['letters'].upcase

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = URI.parse(url).open.read
    fetched_word = JSON.parse(word_serialized)

    check_word = @word.chars
    checking_word = true
    copy_of_letters = @letters.dup.chars
    check_word.each do |letter|
      if copy_of_letters.include?(letter)
        copy_of_letters.delete_at(copy_of_letters.find_index(letter))
      else
        checking_word = false
      end
    end

    @results = if !fetched_word['found']
                 "#{@word} is a invalid word. Please retry !"
               elsif !checking_word
                 "Sorry but #{@word} is not using #{@letters}"
               else
                 "Congratutaltions ! #{@word} is a valid world"
               end
  end
end
