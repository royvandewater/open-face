class Deck
  VALUES = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
  SUITES = ['H', 'C', 'D', 'S']
  FULL_DECK = SUITES.map {|suite| VALUES.map {|value| "#{value}#{suite}" }}.flatten

  def initialize
    @cards = FULL_DECK.dup.shuffle
  end

  def next_card
    @cards.pop
  end

  def to_s
    @cards.to_s
  end
end
