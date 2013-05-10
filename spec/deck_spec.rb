require_relative 'spec_helper'
require_relative '../deck'

describe Deck do
  describe 'Dealing the next card' do
    before :each do
      @deck = Deck.new
      @card = @deck.next_card
    end

    it 'should give me a card' do
      @card.should be
    end
  end

  describe "dealing all 52 cards" do
    before :each do
      @deck = Deck.new
      @cards = []
      52.times { @cards << @deck.next_card }
    end

    it "should not deal any cards twice" do
      @cards.uniq.count.should == 52
    end
  end
end
