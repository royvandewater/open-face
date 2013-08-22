#!/usr/bin/env ruby
require 'debugger'
require_relative 'deck'
require_relative 'dumb_player'

class DebugGame
  attr_accessor :player

  def initialize(options={})
    @deck   = options[:deck]
    @player = options[:player]
  end

  def initial_hand
    @initial_hand ||= (1..5).map { @deck.next_card }
  end

  def play!
    @player.start initial_hand

    8.times do
      next_card = @deck.next_card

      print_hands!
      puts "next card: #{next_card}"
      wait_for_any_key

      @player.take next_card
    end
  end

  def print_hands!
    top,middle,bottom = player.hands
    puts "T: #{top}"
    puts "M: #{middle}"
    puts "B: #{bottom}\n"
  end

  def print_results!
    puts "\n#{player.name} #{'(misset)' if player.misset}"
    print_hands!
  end

  def wait_for_any_key
    puts 'Press any key'
    state = `stty -g`
    `stty raw -echo -icanon isig`
    STDIN.getc
  ensure
    `stty #{state}`
  end
end


if __FILE__ == $0
  deck   = Deck.new
  player = DumbPlayer.new :name => 'Dumb Player'

  game = DebugGame.new :player => player, :deck => deck
  game.play!

  puts "\n\nResults"
  puts "=======\n"
  game.print_results!
end
