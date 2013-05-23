require_relative 'spec_helper'
require_relative '../hand'

describe Hand do
  describe "initialize" do
    it "should take a variable number of cards" do
      Hand.new(:size => 5).should be
    end

    it "should take a set of cards to bootstrap itself with" do
      @hand = Hand.new(:size => 5, :cards => ['H2', 'H5'])
      @hand.count.should == 2
    end

    it "should throw an exception if initialized with more cards than its capacity" do
      expect { Hand.new(:size => 1, :cards => ['H2', 'H5']) }.to raise_error ArgumentError
    end
  end

  describe "adding cards" do
    it "should take cards" do
      @hand = Hand.new :size => 1
      @hand.add('3H').should be_true
    end

    it "should not accept new cards if it's at capacity" do
      @hand = Hand.new :size => 1
      @hand.add '2H'
      @hand.add('3H').should be_false
    end
  end

  describe "counting cards" do
    it "should store cards that have been added" do
      @hand = Hand.new :size => 5
      @hand.add '2H'
      @hand.count.should == 1
    end

    it "should be able to store more than one card" do
      @hand = Hand.new :size => 5
      @hand.add '2H'
      @hand.add '4H'
      @hand.count.should == 2
    end
  end

  describe "comparing hands" do
    context "when the hand1 is better than hand2" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['2H', '2D', '3S', '4S', '5S']
        @hand2 = Hand.new :size => 5, :cards => ['2H', 'JD', '3S', '4S', '5S']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a better high card than hand2" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '4S', '5C', '6D', 'JC']
        @hand2 = Hand.new :size => 5, :cards => ['3H', '4S', '5C', '6C', '8C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a better two of a kind than hand2" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '3S', '4C', '5D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '1C', '9C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a three of a kind" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '3S', '3C', '5D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '1C', '9C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a better three of a kind than hand2" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '3S', '3C', '5D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '9C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a four of a kind" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '3S', '3C', '3D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '1C', '9C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a better four of a kind than hand2" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '3S', '3C', '3D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '2D', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a two pair" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['2H', '2S', '4C', '4D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['3H', '3S', '1C', '9C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a better two pair than hand2" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['2H', '2S', '6C', '6D', '7C']
        @hand2 = Hand.new :size => 5, :cards => ['3H', '3S', '5C', '5C', '2C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a straight" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['2H', '3S', '4C', '5D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['3H', '3S', '1C', '9C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a better straight than hand2" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['7H', '8S', '9C', '10D', 'JC']
        @hand2 = Hand.new :size => 5, :cards => ['3H', '4S', '5C', '6C', '7C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has three of a kind and hand2 has a full house" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '3S', '3C', '5D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '5C', '5C']
      end

      it "should return -1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == -1
      end

      it "should return 1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == 1
      end
    end

    context "when hand1 has a straight and hand2 has a three of a kind" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '4S', '5C', '6D', '7C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '8C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a straight and hand2 has a full house" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '4S', '5D', '6D', '7C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '5C', '5C']
      end

      it "should return -1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == -1
      end

      it "should return 1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == 1
      end
    end

    context "when hand1 has two pair and hand2 has a full house" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '3S', '6C', '5D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '5C', '5C']
      end

      it "should return -1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == -1
      end

      it "should return 1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == 1
      end
    end

    context "when hand1 has four of a kind and hand2 has a full house" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '3S', '3C', '3D', '6C']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '5C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a flush and hand2 has a full house" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '7H', '2H', '8H', 'JH']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '5C', '5C']
      end

      it "should return -1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == -1
      end

      it "should return 1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == 1
      end
    end

    context "when hand1 has a flush and hand2 has a straight" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '7H', '2H', '8H', 'JH']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '3S', '4C', '5C', '6C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a straight flush and hand2 has a straight" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['3H', '4H', '5H', '6H', '7H']
        @hand2 = Hand.new :size => 5, :cards => ['2C', '7C', 'QC', '9C', '10C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end

    context "when hand1 has a royal flush and who cares what hand2 has" do
      before :each do
        @hand1 = Hand.new :size => 5, :cards => ['10C', 'JC', 'QC', 'KC', 'AC']
        @hand2 = Hand.new :size => 5, :cards => ['2H', '2S', '2C', '5C', '5C']
      end

      it "should return 1 when hand1 is space shipped with hand2" do
        (@hand1 <=> @hand2).should == 1
      end

      it "should return -1 when hand2 is space shipped with hand1" do
        (@hand2 <=> @hand1).should == -1
      end
    end
  end

  describe "two of a kind" do
    it "should return the face value of the cards if there are two of a kind" do
      @hand = Hand.new :size => 2, :cards => ['2H', '2D']
      @hand.two_of_a_kind.should == 2
    end
  end

  describe "three of a kind" do
    it "should return the face value of the cards if there are three of a kind" do
      @hand = Hand.new :size => 3, :cards => ['2H', '2D', '2S']
      @hand.three_of_a_kind.should == 2
    end
  end

  describe "four of a kind" do
    it "should return the face value of the cards if there are four of a kind" do
      @hand = Hand.new :size => 4, :cards => ['2H', '2D', '2S', '2C']
      @hand.four_of_a_kind.should == 2
    end
  end

  describe "two pair" do
    it "should return the face value of the higher of the two pair" do
      @hand = Hand.new :size => 4, :cards => ['2H', '2D', '3S', '3C']
      @hand.two_pair.should == 3
    end

    it "should not return true if all I have is a two of a kind" do
      @hand = Hand.new :size => 4, :cards => ['2H', '2D', '3S', '4C']
      @hand.two_pair.should be_nil
    end
  end

  describe "full house" do
    it "should return the value of the full house" do
      @hand = Hand.new :size => 5, :cards => ['2H', '2D', '2S', '3H', '3D']
      @hand.full_house.should == 2
    end
  end

  describe "straight" do
    it "should return the high card if there is a straight" do
      @hand = Hand.new :size => 5, :cards => ['4H', '5D', '6S', '7H', '8D']
      @hand.straight.should == 8
    end
  end

  describe "flush" do
    it "should return the high card if there is a flush" do
      @hand = Hand.new :size => 5, :cards => ['4H', '5H', '6H', '7H', 'QH']
      @hand.flush.should == 12
    end

    it "should return nil if there is not a flush" do
      @hand = Hand.new :size => 5, :cards => ['4C', '5H', '6H', '7H', 'QH']
      @hand.flush.should be_nil
    end
  end

  describe "straight flush" do
    it "should return the high card if there is a straight flush" do
      @hand = Hand.new :size => 5, :cards => ['3C', '4C', '5C', '6C', '7C']
      @hand.straight_flush.should == 7
    end
  end

  describe "royal flush" do
    it "should return a 14 if there is a royal flush" do
      @hand = Hand.new :size => 5, :cards => ['10C', 'JC', 'QC', 'KC', 'AC']
      @hand.royal_flush.should == 14
    end
  end

  describe "value of a card" do
    before :each do
      @hand = Hand.new
    end

    it "should return 2 when given a 2 of hearts" do
      @hand.value_of('2H').should == 2
    end

    it "should return 10 when given a 10 of spades" do
      @hand.value_of('10S').should == 10
    end

    it "should return 11 when given a Jack of diamonds" do
      @hand.value_of('JD').should == 11
    end
  end
end
