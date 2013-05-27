#!/usr/bin/env ruby

require_relative 'deck'
require_relative 'dumb_player'
require_relative 'open_face'

class Stats
end


if __FILE__ == $0
  @attempts = (ARGV[0] || 1000).to_i
  @missets  = 0
  @attempts.times do
    @deck      = Deck.new
    @player    = DumbPlayer.new :name => 'Dumb Player'
    @open_face = OpenFace.new :players => [@player], :deck => @deck
    @open_face.play!

    @missets += 1 if @player.misset
  end

  puts "#{@player} misset #{@missets}/#{@attempts} times"
  puts "failure rate: #{100 * @missets / @attempts}%"
end
