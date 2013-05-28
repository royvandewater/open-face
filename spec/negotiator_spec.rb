require_relative 'spec_helper'
require_relative '../negotiator'
require_relative '../card_holder'

describe Negotiator do
  describe 'mediate' do
    context 'when player 1 scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['4C', '5C', '6C', '7C', '10H']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 6 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(6)
        @player2.should_receive(:add_points).with(-6)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has two hands better than player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['4C', '5C', '6C', '7C', '9H']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', 'JD']]
        @negotiator = Negotiator.new @player1, @player2
      end
      
      it "should give 1 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(1)
        @player2.should_receive(:add_points).with(-1)
        @negotiator.negotiate!
      end
    end

    context 'when player 2 has two hands better than player 1' do
      before :each do
        @player1 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', 'JD']]
        @player2 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['4C', '5C', '6C', '7C', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end
      
      it "should give 1 of player 1's points to player 2" do
        @player1.should_receive(:add_points).with(-1)
        @player2.should_receive(:add_points).with(1)
        @negotiator.negotiate!
      end
    end
  end
end
