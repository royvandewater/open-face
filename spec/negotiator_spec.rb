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

    context 'when player 2 scoops player 1' do
      before :each do
        @player1 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @player2 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['4C', '5C', '6C', '7C', '10H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 6 of player 1's points to player 2" do
        @player1.should_receive(:add_points).with(-6)
        @player2.should_receive(:add_points).with(6)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has a full house on the bottom and also scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['JC', 'JD', 'JS', 'QC', 'QH']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 12 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(12)
        @player2.should_receive(:add_points).with(-12)
        @negotiator.negotiate!
      end
    end

    context 'when player 2 has a full house on the bottom and also scoops player 1' do
      before :each do
        @player1 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @player2 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['JC', 'JD', 'JS', 'QC', 'QH']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 12 of player 1's points to player 2" do
        @player1.should_receive(:add_points).with(-12)
        @player2.should_receive(:add_points).with(12)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has a better full house on the bottom than player 2 and also scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['JC', 'JD', 'JS', 'QC', 'QH']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['9S', '9C', '9D', '7S', '7H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 12 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(12)
        @player2.should_receive(:add_points).with(-12)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has a straight on the bottom and also scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['10C', 'JD', 'QS', 'KC', 'AH']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 8 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(8)
        @player2.should_receive(:add_points).with(-8)
        @negotiator.negotiate!
      end
    end

    context 'when player 2 has a straight on the bottom and also scoops player 1' do
      before :each do
        @player1 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @player2 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['10C', 'JD', 'QS', 'KC', 'AH']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 8 of player 1's points to player 2" do
        @player1.should_receive(:add_points).with(-8)
        @player2.should_receive(:add_points).with(8)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has a flush on the bottom and also scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['8C', 'JC', 'QC', '4C', 'AC']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 10 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(10)
        @player2.should_receive(:add_points).with(-10)
        @negotiator.negotiate!
      end
    end

    context 'when player 2 has a flush on the bottom and also scoops player 1' do
      before :each do
        @player1 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @player2 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['8C', 'JC', 'QC', '4C', 'AC']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 10 of player 1's points to player 2" do 
        @player1.should_receive(:add_points).with(-10)
        @player2.should_receive(:add_points).with(10)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has a 4 of a kind on the bottom and also scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['JH', 'JC', 'JS', 'JD', 'AC']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 16 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(16)
        @player2.should_receive(:add_points).with(-16)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has a straight flush on the bottom and also scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['2H', '3H', '4H', '5H', '6H']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 21 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(21)
        @player2.should_receive(:add_points).with(-21)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has a royal flush on the bottom and also scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['10H', 'JH', 'QH', 'KH', 'AH']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 31 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(31)
        @player2.should_receive(:add_points).with(-31)
        @negotiator.negotiate!
      end
    end

    context 'when player 1 has a flush on the middle and also scoops player 2' do
      before :each do
        @player1 = CardHolder.new [['2C', '3C', '5C'],['2H', '3H', '4H', '5H', '9H'],['8C', 'JC', 'QC', '4C', 'AC']]
        @player2 = CardHolder.new [['2S', '3S', '4S'],['2H', '3H', '4D', '5D', '8D'],['4S', '5S', '6S', '7S', '9H']]
        @negotiator = Negotiator.new @player1, @player2
      end

      it "should give 14 of player 2's points to player 1" do
        @player1.should_receive(:add_points).with(14)
        @player2.should_receive(:add_points).with(-14)
        @negotiator.negotiate!
      end
    end
  end

  describe 'handing out royalties when its just one player' do
    before :each do
      @player = CardHolder.new [['2C', '3C', '5C'],['2D', '3D', '4H', '5H', '9H'],['10C', 'JH', 'QH', 'KH', 'AH']]
      @negotiator = Negotiator.new @player
    end

    it 'should make up money like the federal reserve and give it to the player' do
      @player.should_receive(:add_points).with(2)
      @negotiator.negotiate!
    end
  end
end
