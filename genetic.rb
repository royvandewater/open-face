#!/usr/bin/env ruby

require 'progressbar'
require_relative 'deck'
require_relative 'dumb_player'
require_relative 'open_face'

class Genetic
  def initialize(options={})
    @repetitions = options[:repetitions]
    @bottom_cuttoff = 0
    @middle_cuttoff = 0
    @experiments = []
  end

  def run!
    progressbar = ProgressBar.new "Progress", 255
    (0..14).each do |bottom_cuttoff|
      (0..14).each do |middle_cuttoff|
        progressbar.inc

        experiment = Experiment.new :repetitions => @repetitions,
                                     :bottom_cuttoff => bottom_cuttoff,
                                     :middle_cuttoff => middle_cuttoff
        experiment.run!
        @experiments << experiment
      end
    end
    progressbar.finish
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
    @bottom_cuttoff = options[:bottom_cuttoff]
    @middle_cuttoff = options[:middle_cuttoff]
    @missets = 0
  end

  def failure_rate
    100 * @missets / @repetitions
  end

  def run!
    @repetitions.times do
      @deck      = Deck.new
      @player    = DumbPlayer.new :name => 'Dumb Player', :bottom_cuttoff => @bottom_cuttoff, :middle_cuttoff => @middle_cuttoff
      @open_face = OpenFace.new :players => [@player], :deck => @deck
      @open_face.play!
      @missets += 1 if @player.misset
    end
  end

  def to_s
    "[#{@bottom_cuttoff.to_s.ljust(2)}, #{@middle_cuttoff.to_s.ljust(2)}] - #{failure_rate.round(2)}%"
  end

  def <=>(experiment)
    failure_rate <=> experiment.failure_rate
  end
end

if __FILE__ == $0
  @genetic = Genetic.new :repetitions => (ARGV[0] || 1000).to_i
  @genetic.run!
  @genetic.print_results!
end
