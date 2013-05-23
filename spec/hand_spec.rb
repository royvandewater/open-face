require_relative 'spec_helper'
require_relative '../hand'

describe Hand do
  describe "initialize" do
    it "should take a variable number of cards" do
      Hand.new(:size => 5).should be
    end

    it "should take a set of cards to bootstrap itself with" do
      @hand = Hand.new(:size => 5, :cards => ['H2', 'H5'])
      @hand.card_count.should == 2
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
      @hand.card_count.should == 1
    end

    it "should be able to store more than one card" do
      @hand = Hand.new :size => 5
      @hand.add '2H'
      @hand.add '4H'
      @hand.card_count.should == 2
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
    it "should return true if there are is a full house" do
      @hand = Hand.new :size => 5, :cards => ['2H', '2D', '2S', '3H', '3D']
      @hand.full_house.should == 2
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
