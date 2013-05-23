#!/usr/bin/env ruby

require 'active_support/core_ext/array' # provides second and other goodies :-)
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
    @players.each do |player|
      top,middle,bottom = player.hands
      puts player
      puts "T: #{top}"
      puts "M: #{middle}"
      puts "B: #{bottom}"
    end

    puts "Winners"

    top_player, top_hand       = top_winner
    middle_player, middle_hand = middle_winner
    bottom_player, bottom_hand = bottom_winner

    puts "T: #{top_player} #{top_hand}"
    puts "M: #{middle_player} #{middle_hand}"
    puts "B: #{bottom_player} #{bottom_hand}"
  end


  protected
  def bottom_winner
    bottom_hand   = @players.map{ |player| player.hands.last }.sort.last
    bottom_player = @players.detect {|player| player.hands.last == bottom_hand }

    [bottom_player, bottom_hand]
  end

  def middle_winner
    middle_hand   = @players.map{ |player| player.hands.second }.sort.last
    middle_player = @players.detect {|player| player.hands.second == middle_hand }

    [middle_player, middle_hand]
  end

  def top_winner
    top_hand   = @players.map{ |player| player.hands.first }.sort.last
    top_player = @players.detect {|player| player.hands.first == top_hand }

    [top_player, top_hand]
  end
end

if __FILE__ == $0
  @deck      = Deck.new
  @player1   = AIPlayer.new :name => 'Player 1'
  @player2   = AIPlayer.new :name => 'Player 2'
  @player3   = AIPlayer.new :name => 'Player 3'
  @player4   = AIPlayer.new :name => 'Player 4'
  @open_face = OpenFace.new :players => [@player1, @player2, @player3, @player4], :deck => @deck
  @open_face.play!
end
