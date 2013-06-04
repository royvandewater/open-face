#!/usr/bin/env ruby

require 'active_support/core_ext/object' # provides try and other goodies :-)
require 'progressbar'
require_relative 'deck'
require_relative 'dumb_player'
require_relative 'open_face'

class Stats
  def initialize(options={})
    @repetitions = options[:repetitions] || 1000

    @players = [
      DumbPlayer.new(:name => 'Dumb Player 1'),
      DumbPlayer.new(:name => 'Dumb Player 2'),
      AIPlayer.new(  :name => 'AI Player   3'),
      AIPlayer.new(  :name => 'AI Player   4'),
    ]
  end

  def play!
    # progressbar = ProgressBar.new "Progress", @repetitions
    @repetitions.times do |i|
      puts "Round #{i}"
      puts "============"
      open_face = OpenFace.new(:players => @players, :deck => Deck.new)
      open_face.play!
      open_face.print_hands!

      # progressbar.inc
    end
    # progressbar.finish
  end

  def print_results!
    @players.each do |player|
      puts "#{player.name} - #{player.score}"
    end
  end
end


if __FILE__ == $0
  repetitions = ARGV[0].try :to_i

  @stats = Stats.new :repetitions => repetitions
  @stats.play!
  puts "\n\nResults:"
  @stats.print_results!
end
