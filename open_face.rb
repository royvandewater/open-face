#!/usr/bin/env ruby

require_relative 'deck'
require_relative 'ai_player'

class OpenFace
  def initialize(options={})
    @deck = options[:deck]
    @players = options[:players]
  end

  def deal_initial_hand!
    @players.each do |player|
      cards = (1..5).map { @deck.next_card }
      player.start cards
    end
  end

  def deal_turn!
    @players.each do |player|
      player.take @deck.next_card
    end
  end

  def play!
    deal_initial_hand!

    8.times do
      deal_turn!
    end

    rank_hands!
  end

  def rank_hands!
    @players.each_with_index do |player, i|
      top,middle,bottom = player.hands
      puts "Player #{i}"
      puts "T: #{top}"
      puts "M: #{middle}"
      puts "B: #{bottom}"
    end
  end
end

if __FILE__ == $0
  @deck      = Deck.new
  @player1   = AIPlayer.new
  @player2   = AIPlayer.new
  @player3   = AIPlayer.new
  @player4   = AIPlayer.new
  @player5   = AIPlayer.new
  @open_face = OpenFace.new :players => [@player1, @player2, @player3, @player4], :deck => @deck
  @open_face.play!
end
