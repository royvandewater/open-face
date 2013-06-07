require_relative 'spec_helper'
require_relative '../dumb_player'

describe DumbPlayer do
  describe 'take_initial' do
    before :each do
      @player = DumbPlayer.new
    end

    it 'should pursue spade flushes when appropriate' do
      @player.take_initial ["8S", "5S", "AS", "KC", "3D"]
      top, middle, bottom = @player.hands
      top.sort.should    == ['3D']
      middle.sort.should == ['KC']
      bottom.sort.should == ['5S','8S','AS']
    end

    it 'should pursue club flushes when appropriate' do
      @player.take_initial ["JH", "6H", "2C", "QC", "7C"]
      top, middle, bottom = @player.hands
      top.sort.should    == []
      middle.sort.should == ['6H','JH']
      bottom.sort.should == ['2C','7C','QC']
    end

    it 'should put the full house on the bottom when it gets dealt one' do
      @player.take_initial ["7C", "8H", "7H", "8S", "8D"]
      top, middle, bottom = @player.hands
      top.sort.should    == []
      middle.sort.should == []
      bottom.sort.should == ["7C", "7H", "8H", "8S", "8D"]
    end
  end

  describe 'put_in_bottom?' do
    context 'when the player is on track to get a flush and recieves another card of the same suite' do
      before :each do
        @player = DumbPlayer.new :bottom => ['2C','7C','QC']
      end

      context 'the player recieves another card of the same suite' do
        before :each do
          @player.take '4C'
        end
          
        it 'should place it in the bottom' do
          @player.hands.third.should include '4C'
        end
      end

      context 'the player recieves a card of a different suite' do
        before :each do
          @player.take '4H'
        end
          
        it 'should not place it in the bottom' do
          @player.hands.third.should_not include '4H'
        end
      end
    end
  end
end
