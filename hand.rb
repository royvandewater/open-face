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

  def two_of_a_kind?
    @cards.group_by do |card|
      value_of card
    end.detect do |value, cards|
      cards.count == 2
    end
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
    if two_of_a_kind?
      1
    else
      -1
    end
  end
end
