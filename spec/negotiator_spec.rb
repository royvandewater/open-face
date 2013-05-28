require_relative 'spec_helper'
require_relative '../negotiator'

describe Negotiator do
  describe 'mediate' do
    context 'when player 1 scoops player 2' do
      it "should give 6 of player 2's points to player 1" do
        @player1 = mock(:hands => [['2C', '3C', '4C'],['2D', '3D', '4H', '5H', '8H'],['4C', '5C', '6C', '7C', '9H']])
        @player2 = mock(:hands => [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9D']])
        @negotiator = Negotiator.new @player1, @player2

        @player1.should_receive(:add_points).with(6)
        @player2.should_receive(:add_points).with(-6)
        @negotiator.negotiate!
      end
    end
  end
end
