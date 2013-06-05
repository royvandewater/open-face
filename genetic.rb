#!/usr/bin/env ruby

require 'progressbar'
require_relative 'deck'
require_relative 'dumb_player'
require_relative 'open_face'

class Genetic
  def initialize(options={})
    @repetitions = options[:repetitions]
    @experiments = []
  end

  def run!
    experiment = Experiment.new :repetitions => @repetitions
    experiment.run!
    @experiments << experiment
  end

  def print_results!
    @experiments.sort.reverse.each do |experiment|
      puts experiment
    end
  end
end

class Experiment
  def initialize(options={})
    @repetitions    = options[:repetitions]
    @missets = 0
  end

  def failure_rate
    100 * @missets / @repetitions
  end

  def run!
    progressbar = ProgressBar.new "Progress", 255
    @repetitions.times do
      @deck      = Deck.new
      @player    = DumbPlayer.new :name => 'Dumb Player'
      @open_face = OpenFace.new :players => [@player], :deck => @deck
      @open_face.play!
      @missets += 1 if @player.misset
      progressbar.inc
    end
    progressbar.finish
  end

  def score
    @player.score
  end

  def to_s
    "#{failure_rate.round(2)}% - #{score}"
  end

  def <=>(experiment)
    # score <=> experiment.score
    failure_rate <=> experiment.failure_rate
  end
end

if __FILE__ == $0
  @genetic = Genetic.new :repetitions => (ARGV[0] || 1000).to_i
  @genetic.run!
  @genetic.print_results!
end
