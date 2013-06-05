require_relative 'player'

class DumbPlayer < Player
  def put_in_bottom?(card)
    return false if @bottom.count >= 5
    value_of(card) >= @bottom_cuttoff
  end

  def put_in_middle?(card)
    return false if @middle.count >= 5
    value_of(card) >= @middle_cuttoff
  end

  def take_initial(initial_hand)
    grouped_cards = initial_hand.group_by {|card| suite(card)}

    grouped_cards.each_value do |cards| 
      if cards.count >= 3
        @bottom.concat cards
      elsif cards.all? {|card| value_of(card) > 4}
        @middle.concat cards
      else
        @top.concat cards
      end
    end
  end

  protected
  def suite(card)
    SUITES[card[-1]]
  end
end
