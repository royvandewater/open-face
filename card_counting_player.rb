require_relative 'player'

class CardCountingPlayer < Player
  def probability_of_getting_a(card)
    return 0 if cards.include? card
    1 - ((13 - cards.count).to_f / (52 - cards.count).to_f)
  end

  def cards
    hands.sum &:cards
  end

  def put_in_bottom?(card)
  end

  def put_in_middle?(card)
  end
end
