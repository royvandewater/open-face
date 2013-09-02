require_relative 'spec_helper'
require_relative '../lib/deck'

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
      52.times do
        @cards << @deck.next_card
      end
    end

    it "should not deal any cards twice" do
      @cards.uniq.count.should == 52
    end

    it "should be unlikely to deal all 52 cards in the same order twice" do
      deck = Deck.new
      new_cards = []
      52.times { new_cards << deck.next_card }

      @cards.should_not == new_cards
    end
  end
end
