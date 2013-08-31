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

  describe 'probability_of_getting' do
    context 'when 11 of 13 cards have already been dealt' do
      before :each do
        @sut = CardCountingPlayer.new(
          :top    => ['2C'],
          :middle => ['2H', '3H', '4H', '5H', '6H'],
          :bottom => ['2S', '3S', '4S', '5S', '6S'],
        )
      end

      it 'should calculate a probability of 2/41 when trying to get one card' do
        expect(@sut.probability_of_getting 1, :of => ['JH']).to eq 2.0/41.0
      end

      it 'should calculate a probability of 1/820 when trying to get two cards' do
        expect(@sut.probability_of_getting 2, :of => ['JH', 'QH']).to eq 1.0/820.0
      end

      it 'should calculate a probability of 3/820 when trying to get any two of three cards' do
        expect(@sut.probability_of_getting 2, :of => ['JH', 'QH', 'KH']).to eq 3.0/820.0
      end

      it 'should calculate a probability of 3/410 when trying to get any two of four cards' do
        expect(@sut.probability_of_getting 2, :of => ['JH', 'QH', 'KH', 'AH']).to eq 3.0/410.0
      end

      it 'should calculate a probability of 1/82 when trying to get any two of five cards' do
        expect(@sut.probability_of_getting 2, :of => ['10H', 'JH', 'QH', 'KH', 'AH']).to eq 1.0/82.0
      end

      it 'should calculate a probability of 3/164 when trying to get any two of six cards' do
        expect(@sut.probability_of_getting 2, :of => ['9H', '10H', 'JH', 'QH', 'KH', 'AH']).to eq 3.0/164.0
      end

      it 'should calculate a probability of 0 when trying to get three cards' do
        expect(@sut.probability_of_getting 3, :of => ['JH', 'QH', 'KH']).to eq 0
      end
    end

    context 'when 10 of 13 cards have already been dealt' do
      before :each do
        @sut = CardCountingPlayer.new(
          :top    => [],
          :middle => ['2H', '3H', '4H', '5H', '6H'],
          :bottom => ['2S', '3S', '4S', '5S', '6S'],
        )
      end

      # it 'should calculate a probability of 3/42 when trying to get one card' do
      #   expect(@sut.probability_of_getting 1, :of => ['JH']).to eq 3.0/42.0
      # end

      # it 'should calculate a probability of 3/861 when trying to get two cards' do
      #   expect(@sut.probability_of_getting 2, :of => ['JH', 'QH']).to eq 3.0/861.0
      # end

      # it 'should calculate a probability of 3/820 when trying to get any two of three cards' do
      #   expect(@sut.probability_of_getting 2, :of => ['JH', 'QH', 'KH']).to eq 3.0/820.0
      # end

      # it 'should calculate a probability of 0 when trying to get three cards' do
      #   expect(@sut.probability_of_getting 3, :of => ['JH', 'QH', 'KH']).to eq 0
      # end
    end

    # context 'when one a card has been dealt'
  end
end
