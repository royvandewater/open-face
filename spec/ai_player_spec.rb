require_relative 'spec_helper'
require_relative '../lib/ai_player'

describe AIPlayer do
  describe "value of a card" do
    before :each do
      @ai_player = AIPlayer.new
    end

    it "should return 2 when given a 2 of hearts" do
      @ai_player.value_of('2H').should == 2
    end

    it "should return 10 when given a 10 of spades" do
      @ai_player.value_of('10S').should == 10
    end

    it "should return 11 when given a Jack of diamonds" do
      @ai_player.value_of('JD').should == 11
    end
  end

  describe "placing cards in the bottom hand" do
    it "should should prefer to place high value cards in the bottom" do
      @ai_player = AIPlayer.new
      @ai_player.take 'JD'
      @ai_player.hands.last.should include 'JD'
    end
  end

  describe "placing cards in the middle hand" do
    before :each do
      @ai_player = AIPlayer.new
    end

    it "should prefer to place mid value cards in the middle hand" do
      @ai_player.take '7D'
      @ai_player.hands[1].should include '7D'
    end

    context "when the top hand is entirely full" do
      before :each do
        @ai_player.start ['2D', '2H', '2S']
      end

      it 'should not put a low value card in the top hand' do
        @ai_player.take '2C'
        @ai_player.hands.first.should_not include '2C'
      end

      it 'should put a low value card in the middle hand' do
        @ai_player.take '2C'
        @ai_player.hands[1].should include '2C'
      end
    end

    context "when the top and middle hands are entirely full" do
      before :each do
        @ai_player.start ['2D', '2H', '2S', '3D', '3H', '3S', '3C', '3D']
      end

      it 'should put a low value card in the bottom hand' do
        @ai_player.take '2C'
        @ai_player.hands.last.should include '2C'
      end
    end
  end

  describe "placing cards in the top hand" do
    it "should prefer to place low value cards in the top hand" do
      @ai_player = AIPlayer.new
      @ai_player.take '2D'
      @ai_player.hands.first.should include '2D'
    end
  end

  describe "put_in_bottom?" do
    before :each do
      @ai_player = AIPlayer.new
    end

    context "when the bottom hand is empty" do
      it "should return true if the card has a higher than 9 value" do
        @ai_player.put_in_bottom?('JD').should be_true
      end

      it "should return false if the card has a lower than 9 value" do
        @ai_player.put_in_bottom?('3D').should be_false
      end
    end

    context "when the bottom hand is full" do
      before :each do
        @ai_player.start(['AS', 'AH', 'AD', 'AC', 'KD'])
      end

      it 'should reject even high valued cards' do
        @ai_player.put_in_bottom?('JD').should be_false
      end
    end
  end

  describe "put_in_middle?" do
    before :each do
      @ai_player = AIPlayer.new
    end

    describe "when there is still room left in the middle hand" do
      it "should return true if the card has a higher than 3 value" do
        @ai_player.put_in_middle?('9S').should be_true
      end

      it "should return false when the card is a less than 3 value" do
        @ai_player.put_in_middle?('2S').should be_false
      end
    end

    describe "when there is no room left in the middle hand" do
      before :each do
        @ai_player.start(['7H', '7D', '7C', '7S', '6H'])
      end

      it "should reject even the 3-9 cards" do
        @ai_player.put_in_middle?('6S').should be_false
      end
    end
  end
end
