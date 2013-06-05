require_relative 'spec_helper'
require_relative '../dumb_player'

describe DumbPlayer do
  describe 'take_initial' do
    before :each do
      @player = DumbPlayer.new
    end

    it 'should persue flushes when appropriate' do
      @player.take_initial ["8S", "5S", "AS", "KC", "3D"]
      top, middle, bottom = @player.hands
      top.sort.should    == ['3D']
      middle.sort.should == ['KC']
      bottom.sort.should == ['5S','8S','AS']
    end

    it 'should deal with ["JH", "6H", "2C", "QC", "7C"]' do
      @player.take_initial ["JH", "6H", "2C", "QC", "7C"]
      top, middle, bottom = @player.hands
      top.sort.should    == []
      middle.sort.should == ['6H','JH']
      bottom.sort.should == ['2C','7C','QC']
    end
  end
end
