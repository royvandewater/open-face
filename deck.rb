class Deck
  SUITES = ['H', 'C', 'D', 'S']
  VALUES = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
  FULL_DECK = SUITES.map {|suite| VALUES.map {|value| "#{suite}#{value}" }}.flatten

  def initialize
    @cards = FULL_DECK
  end

  def next_card
    @cards.pop
  end
end
