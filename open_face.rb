#!/usr/bin/env ruby

require 'active_support/core_ext/array' # provides second and other goodies :-)
require_relative 'lib/deck'
require_relative 'lib/ai_player'
require_relative 'lib/dumb_player'
require_relative 'lib/negotiator'

class OpenFace
  def initialize(options={})
    @deck = options[:deck]
    @players = options[:players]

    @players.permutation 2 do |player1, player2|
      player1.other_players << player2
    end
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

  def misset_players
    @players.select &:misset
  end

  def set_players
    @players.select &:set
  end

  def play!
    deal_initial_hand!

    8.times do
      deal_turn!
    end

    if @players.count > 1
      @players.combination 2 do |player1, player2|
        Negotiator.new(player1, player2).negotiate!
      end
    else
      Negotiator.new(@players.first).negotiate!
    end

    @players.each &:game_over!
  end

  def print_hands!
    @players.each do |player|
      top,middle,bottom = player.hands
      puts "\n#{player} #{'(misset)' if player.misset}"
      puts "T: #{top}"
      puts "M: #{middle}"
      puts "B: #{bottom}"
    end
  end

  def print_misset_players!
    puts "\nMisset Players"
    puts "--------------"
    misset_players.each do |player|
      puts player
    end
  end

  def print_results!
    print_hands!
    print_misset_players!
    print_winners!
  end

  def print_winners!
    puts "\nWinners"
    puts "-------"

    top_player, top_hand       = top_winner
    middle_player, middle_hand = middle_winner
    bottom_player, bottom_hand = bottom_winner

    puts "T: #{top_player} #{top_hand}"
    puts "M: #{middle_player} #{middle_hand}"
    puts "B: #{bottom_player} #{bottom_hand}"

    puts "\nScores"
    puts "-------"
    @players.each do |player|
      puts "#{player.name} - #{player.score}"
    end
  end

  protected
  def bottom_hand
    set_players.map{ |player| player.hands.last }.sort.last
  end

  def bottom_player
    set_players.detect {|player| player.hands.last == bottom_hand }
  end

  def bottom_winner
    [bottom_player, bottom_hand]
  end

  def middle_hand
    set_players.map{ |player| player.hands.second }.sort.last
  end

  def middle_player
    set_players.detect {|player| player.hands.second == middle_hand }
  end

  def middle_winner
    [middle_player, middle_hand]
  end

  def top_hand
    set_players.map{ |player| player.hands.first }.sort.last
  end

  def top_player
    set_players.detect {|player| player.hands.first == top_hand }
  end

  def top_winner
    [top_player, top_hand]
  end
end

if __FILE__ == $0
  @deck      = Deck.new
  @player1   = DumbPlayer.new :name => 'Du Player 1'
  @player2   = DumbPlayer.new :name => 'Du Player 2'
  @player3   = AIPlayer.new :name =>   'AI Player 3'
  @player4   = AIPlayer.new :name =>   'AI Player 4'
  @open_face = OpenFace.new :players => [@player1, @player2, @player3, @player4], :deck => @deck
  @open_face.play!
  @open_face.print_results!
end
