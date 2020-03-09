require 'open-uri'

class GamesController < ApplicationController
  def new
    source = ('A'..'Z').to_a
    @random_grid = []
    8.times { @random_grid << source[rand(source.size)] }
    @start_time = Time.now
    @random_grid
  end

  def score
    end_time = Time.now
    time = params[:start_time].to_time
    @attempt = params[:attempt]
    attempt_tested = JSON.parse(getting_url(@attempt))

    if included?(@attempt.upcase, params[:random_grid])
      if attempt_tested['found']
        @result = found_existing_word(@attempt, time, end_time)
      else
        @result = not_found_english_word(time, end_time)
      end
    else
      @result = not_in_the_grid_word(time, end_time)
    end
  end

  def getting_url(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    open(url).read
  end

  private

  def included?(attempt, grid)
    attempt_hash = {}
    grid_hash = {}
    attempt.chars.each do |letter|
      attempt_hash[letter] = attempt_hash[letter] ? attempt_hash[letter] + 1 : 1
    end
    grid.chars.each do |letter|
      grid_hash[letter] = grid_hash[letter] ? grid_hash[letter] + 1 : 1
    end
    attempt_hash.all? { |letter| attempt_hash[letter] == grid_hash[letter] }
  end

  def found_existing_word(attempt, start_time, end_time)
    attempt_sorted = attempt.upcase.split('').sort!
    { time: end_time - start_time,
      message: 'Well done',
      score: attempt_sorted.length * 200 - (end_time - start_time) }
  end

  def not_found_english_word(start_time, end_time)
    { time: end_time - start_time,
      message: 'not an english word',
      score: 0 }
  end

  def not_in_the_grid_word(start_time, end_time)
    { time: end_time - start_time,
      message: 'not in the grid',
      score: 0 }
  end

  def last_case_senario(start_time, end_time)
    { time: end_time - start_time,
      message: 'not in the grid',
      score: 0 }
  end

  def consecutive_letter_result(start_time, end_time)
    { time: end_time - start_time,
      message: 'not in the grid',
      score: 0 }
  end
end
