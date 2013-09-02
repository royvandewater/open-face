require_relative 'spec_helper'
require_relative '../lib/dumb_player'

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
      top.sort!.cards.should    == ['6H']
      middle.sort!.cards.should == ['JH']
      bottom.sort!.cards.should == ['2C','7C','QC']
    end

    it 'should pursue diamond flushes when appropriate' do
      @player.take_initial ["KD", "AD", "QC", "6C", "8D"]
      top, middle, bottom = @player.hands
      top.sort!.cards.should    == ['6C']
      middle.sort!.cards.should == ['QC']
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
    context 'when the player is on track to get a flush' do
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

      context 'the player recieves a low value card of a different suite' do
        before :each do
          @player.take '4H'
        end

        it 'should not place it in the bottom' do
          @player.hands.third.should_not include '4H'
        end
      end

      context 'the player recieves a high value card of a different suite' do
        before :each do
          @player.take 'KD'
        end

        it 'should not place it in the bottom' do
          @player.hands.third.should_not include 'KD'
        end
      end
    end

    context 'the player already has a pair in the bottom' do
      before :each do
        @player = DumbPlayer.new(
          :top    => [],
          :middle => ['8C', '4H'],
          :bottom => ['QH', '10C', 'QS', 'KS'],
        )
      end

      context 'the player recieves a card with slightly less value than the bottom pair' do
        before :each do
          @player.take 'JC'
        end

        it 'should not place it in the bottom' do
          @player.hands.third.should_not include 'JC'
        end
      end
    end

    context 'the player has three cards for a straight in the bottom' do
      before :each do
        @player = DumbPlayer.new(
          :top => [],
          :middle => ["4H", "AS"],
          :bottom => ["2H", "3D", "4C"],
        )
      end

      context 'the player recieves a card that does not fit in the potential straight' do
        before :each do
          @player.take '9D'
        end

        it 'should not place the card on the bottom' do
          @player.hands.third.should_not include '9D'
        end
      end
    end
  end

  describe 'put_in_middle?' do
    context 'the player already has a pair in the middle' do
      before :each do
        @player = DumbPlayer.new(
          :top    => [],
          :middle => ['10S', '10C'],
          :bottom => ['6H', '4H', '8H', '3H', 'KH']
        )
      end

      context 'the player recieves a card with slightly less value than the middle pair' do
        before :each do
          @player.take '9C'
        end

        it 'should not place it in the middle' do
          @player.hands.second.should_not include '9C'
        end
      end
    end

    context 'the player has nothing in the middle, but already has four cards' do
      before :each do
        @player = DumbPlayer.new(
          :top    => [],
          :middle => ['4C', '5C', '6C', 'JS'],
          :bottom => ['6D', '10D', '7D', '8D', 'AD'],
        )
      end

      context 'the player recieves a card that is lower than the highest card (in the middle)' do
        before :each do
          @player.take '9S'
        end

        it 'should not place it in the middle' do
          @player.hands.second.should_not include '9S'
        end
      end
    end
  end

  describe 'put_in_top?' do
    context 'there is already a pair in the middle' do
      before :each do
        @player = DumbPlayer.new(
          :top    => ['2D', '5S'],
          :middle => ['5D', '7S', '7C'],
          :bottom => [],
        )
      end

      context 'the player recieves a low value card' do
        before :each do
          @player.take '4C'
        end

        it 'should not place it on the top' do
          @player.hands.first.should_not include '4C'
        end
      end
    end
  end
end
