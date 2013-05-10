require_relative 'spec_helper'
require_relative '../open_face'

describe OpenFace do
  describe 'constructor' do
    it 'should accept a player and a deck when instantiating' do
      OpenFace.new(:players => [{}], :deck => {}).should be
    end
  end

  describe "dealing the initial hand with one player" do
    it 'should draw five cards from the deck and give them to the player' do
      deck = mock
      deck.should_receive(:next_card).exactly(5).times.and_return(2)
      player = mock
      player.should_receive(:start).with([2,2,2,2,2])

      open_face = OpenFace.new :deck => deck, :players => [player]
      open_face.deal_initial_hand!
    end
  end

  describe "dealing a turn" do
    it "should give each player a card in turn" do
      deck = mock
      deck.should_receive(:next_card).once.and_return(3)
      player = mock
      player.should_receive(:take).with(3)

      open_face = OpenFace.new :deck => deck, :players => [player]
      open_face.deal_turn!
    end
  end
end
