require_relative 'spec_helper'
require_relative '../card_counting_player'

describe CardCountingPlayer do
  describe 'probability_of_getting_a' do
    context 'when no cards have been dealt yet' do
      before :each do
        @sut = CardCountingPlayer.new
      end

      it 'should calculate a probability of 3/4 for getting a JH' do
        # Since the user will get dealt 13 / 52 cards before the game is over
        expect(@sut.probability_of_getting_a 'JH').to eq 3.0 / 4.0
      end
    end

    context 'when the card a 3S is has been dealt' do
      before :each do
        @sut = CardCountingPlayer.new :top => ['3S']
      end

      it 'should calculate a probability of 0 for getting another 3S' do
        expect(@sut.probability_of_getting_a '3S').to eq 0
      end

      it 'should calculate a probability of 39/51 for getting a JH' do
        expect(@sut.probability_of_getting_a 'JH').to eq 39.0/51.0
      end
    end

    context 'when three cards have been dealt' do
      before :each do
        @sut = CardCountingPlayer.new(
          :top => ['QS'],
          :middle => ['QC'],
          :bottom => ['QH']
        )
      end

      it 'should calculate a probability of 39/49 for getting a 3S' do
        expect(@sut.probability_of_getting_a '3H').to eq 39.0/49.0
      end

      it 'should calculate a probability of 0 for getting a QS (already dealt)' do
        expect(@sut.probability_of_getting_a 'QS').to eq 0
      end
    end
  end
end
