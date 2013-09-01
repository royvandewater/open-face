require_relative 'player'
require 'active_support/core_ext/enumerable' # provides sum

class CardCountingPlayer < Player
  def probability_of_getting(number, options={})
    targets = options[:of]

    if number == 1
      first_chance  = targets.count / 41.0
      second_chance = ((41 - targets.count) * targets.count) / (41 * 40).to_f
      first_chance + second_chance
    elsif number == 2
      (targets.count * (targets.count - 1)).to_f / (41 * 40).to_f
    else
      0
    end
  end

  def probability_of_getting_a(card)
    return 0 if cards.include? card
    1 - (13 - cards.count).to_f / (52 - cards.count).to_f
  end

  def cards
    hands.sum &:cards
  end

  def put_in_bottom?(card)
  end

  def put_in_middle?(card)
  end
end



