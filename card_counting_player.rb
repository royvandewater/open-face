require_relative 'player'
require 'active_support/core_ext/enumerable' # provides sum

class CardCountingPlayer < Player
  def probability_of_getting(number, options={})
    case number
    when 1 then 2.0/41.0
    when 3 then 0
    else
      if options[:of].count == 3
        3.0 / 820.0
      else
        1.0 / 820.0
      end
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



