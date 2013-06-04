require_relative 'player'

class AIPlayer < Player

  def put_in_bottom?(card)
    return false if @bottom.count >= 5
    value_of(card) > 9
  end

  def put_in_middle?(card)
    return false if @middle.count >= 5
    value_of(card) > 3
  end
end
