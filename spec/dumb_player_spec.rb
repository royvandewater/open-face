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
      top.sort!.cards.should    == ['3D']
      middle.sort!.cards.should == ['KC']
      bottom.sort!.cards.should == ['5S','8S','AS']
    end

    it 'should pursue club flushes when appropriate' do
      @player.take_initial ["JH", "6H", "2C", "QC", "7C"]
      top, middle, bottom = @player.hands
      top.sort!.cards.should    == []
      middle.sort!.cards.should == ['6H','JH']
      bottom.sort!.cards.should == ['2C','7C','QC']
    end

    it 'should pursue diamond flushes when appropriate' do
      @player.take_initial ["KD", "AD", "QC", "6C", "8D"]
      top, middle, bottom = @player.hands
      top.sort!.cards.should    == []
      middle.sort!.cards.should == ['6C','QC']
      bottom.sort!.cards.should == ['8D','KD','AD']
    end

    it 'should put the full house on the bottom when it gets dealt one' do
      @player.take_initial ["7C", "8H", "7H", "8S", "8D"]
      top, middle, bottom = @player.hands
      top.sort!.cards.should    == []
      middle.sort!.cards.should == []
      bottom.sort!.cards.should == ["7C", "7H", "8H", "8S", "8D"]
    end

    it 'should persue potential straights' do
      @player.take_initial ["KH", "7C", "6D", "AS", "5D"] 
      top, middle, bottom = @player.hands
      top.sort!.cards.should    == []
      middle.sort!.cards.should == ["KH", "AS"]
      bottom.sort!.cards.should == ["5D", "6D", "7C"]
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
