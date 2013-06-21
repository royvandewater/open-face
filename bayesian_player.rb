#!/usr/bin/env ruby

require 'classifier'
require_relative 'player'

class BayesianPlayer < Player
  CLASSIFICATIONS = ['Bottom', 'Middle', 'Top']
  def initialize(options={})
    @classifier = Classifier::Bayes.new *CLASSIFICATIONS
    @moves      = []
    super
  end

  def add_points(points)
    @game_winnings += points
    super
  end

  def card_count
    @bottom.count + @middle.count + @top.count
  end

  def inspect
    @top.to_s + @middle.to_s + @bottom.to_s
  end

  def game_over!
    @moves.each do |move|
      @game_winnings.abs.times do
        if @game_winnings > 0
          @classifier.train move.pile, move.to_s
        else
          (CLASSIFICATIONS - [move.pile]).each do |pile|
            @classifier.train pile, move.to_s
          end
        end
      end
    end
  end

  def start(initial_hand)
    @game_winnings = 0
    super
  end

  def take(card)
    raise 'You gave me too many cards jackass!!' if card_count >= 15


    move = Move.new inspect, card
    move.pile = @classifier.classify move.to_s
    @moves << move

    case move.pile
    when 'Top' then @top << card
    when 'Middle' then @middle << card
    when 'Bottom' then @bottom << card
    else raise "The classifier returned: #{move.pile}"
    end
  end
end

class Move < Struct.new(:hands, :card)
  attr_accessor :pile

  def to_s
    "#{hands} #{card}"
  end
end
