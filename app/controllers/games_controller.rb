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
    raise
    if included?(@attempt.upcase, @random_grid.count)
      if attempt_tested['found'] == false
        @result = not_found_english_word(time, end_time)
      else
        @result = found_existing_word(@attempt, time, end_time)
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
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  def found_existing_word(attempt, start_time, end_time)
    attempt_sorted = attempt.upcase.split('').sort!
    { time: end_time - start_time,
      message: 'Well done',
      score: attempt_sorted.length * 20 - (end_time - start_time) }
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
