require 'active_support/core_ext/object' # provides try and other goodies :-)
require 'active_support/core_ext/array' # provides try and other goodies :-)

class Hand
  def initialize(options={})
    @cards = []
    @size  = options[:size]

    return unless options[:cards]

    raise ArgumentError.new 'number of cards exceeds capacity' if options[:cards].count > @size
    bulk_add options[:cards]
  end

  def add(card)
    return false unless card_count < @size
    @cards << card
  end

  def bulk_add(cards)
    cards.each do |card|
      add card
    end
  end

  def card_count
    @cards.count
  end

  def two_of_a_kind
    n_of_a_kind 2
  end

  def three_of_a_kind
    n_of_a_kind(3) unless two_of_a_kind
  end

  def four_of_a_kind
    n_of_a_kind 4
  end

  def two_pair
    pairs.keys.second
  end

  def full_house
    n_of_a_kind(2) && n_of_a_kind(3)
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

  def <=>(hand)
    if four_of_a_kind or hand.four_of_a_kind
      four_of_a_kind.to_i <=> hand.four_of_a_kind.to_i
    elsif full_house or hand.full_house
      full_house.to_i <=> hand.full_house.to_i
    elsif three_of_a_kind or hand.three_of_a_kind
      three_of_a_kind.to_i <=> hand.three_of_a_kind.to_i
    elsif two_pair or hand.two_pair
      two_pair.to_i <=> hand.two_pair.to_i
    elsif two_of_a_kind or hand.two_of_a_kind
      two_of_a_kind.to_i <=> hand.two_of_a_kind.to_i
    else
      values.max <=> hand.values.max
    end
  end

  def values
    @cards.map do |card|
      value_of card
    end
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
