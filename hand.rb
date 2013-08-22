require 'active_support/core_ext/object' # provides try and other goodies :-)
require 'active_support/core_ext/array' # provides second and other goodies :-)

class Hand
  SUITES = {'H' => :hearts, 'C' => :clubs, 'D' => :diamonds, 'S' => :spades}
  HAND_ORDER = [:royal_flush, :straight_flush, :four_of_a_kind, :full_house, :flush,
                :straight, :three_of_a_kind, :two_pair, :two_of_a_kind, :high_card]

  attr_reader :cards

  def initialize(options={})
    @cards = []
    @size  = options[:size]

    return unless options[:cards]

    @size ||= options[:cards].count
    raise ArgumentError.new 'number of cards exceeds capacity' if options[:cards].count > @size
    bulk_add options[:cards]
  end

  def add(card)
    return false unless count < @size
    @cards << card
  end
  alias_method :<<, :add

  def bulk_add(cards)
    return unless cards
    cards.each do |card|
      add card
    end
  end
  alias_method :concat, :bulk_add

  def count
    @cards.count
  end

  def flush
    return nil unless count == 5 and suites.uniq.count == 1
    high_card
  end

  def four_of_a_kind
    n_of_a_kind 4
  end

  def full_house
    n_of_a_kind(2) && n_of_a_kind(3)
  end

  def high_card
    values.max
  end

  def include?(card)
    @cards.include? card
  end

  def royal_flush
    14 if straight and flush and high_card == 14
  end

  def sort!
    @cards = @cards.sort_by do |card|
      value_of card
    end
    self
  end

  def straight
    return nil if grouped_cards.detect {|value, cards| cards.count > 1}
    high_card if 4 == high_card - values.min
  end

  def straight_flush
    high_card if straight && flush
  end

  def suites
    @cards.map do |card|
      SUITES[card[-1]]
    end.uniq
  end

  def three_of_a_kind
    n_of_a_kind(3) unless two_of_a_kind
  end

  def to_s
    @cards.to_s
  end

  def two_of_a_kind
    n_of_a_kind 2
  end

  def two_pair
    pairs.keys.second
  end

  def value_of(card)
    value = card[0..-2]
    return value.to_i if value[/^[0-9]+$/]

    case value
    when 'J' then 11
    when 'Q' then 12
    when 'K' then 13
    when 'A' then 14
    end
  end

  def values
    @cards.map do |card|
      value_of card
    end
  end

  def <=>(hand)
    HAND_ORDER.each do |hand_type|
      if send(hand_type) or hand.send(hand_type)
        return send(hand_type).to_i <=> hand.send(hand_type).to_i
      end
    end
  end

  def >(hand)
    1 == (self <=> hand)
  end

  private
  def grouped_cards
    @cards.group_by do |card|
      value_of card
    end
  end

  def n_of_a_kind(n)
    grouped_cards.detect do |value, cards|
      cards.count == n
    end.try :first
  end

  def pairs
    grouped_cards.select do |value, cards|
      cards.count == 2
    end
  end
end
