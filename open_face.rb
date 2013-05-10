#!/usr/bin/env ruby

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
  end
end
