require_relative 'spec_helper'
require_relative '../ai_player'

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
      @ai_player.hand[2].should include 'JD'
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
end
