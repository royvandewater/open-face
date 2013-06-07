require_relative 'player'

class DumbPlayer < Player
  def put_in_bottom?(card)
    return false if @bottom.count >= 5

    if @bottom.suites.count == 1 and @bottom.suites.include? suite(card)
      true
    else
      value_of(card) >= 9
    end
  end

  def put_in_middle?(card)
    return false if @middle.count >= 5
    value_of(card) > 3
  end

  def take_initial(initial_hand)
    flush_suite = most_popular_suite(initial_hand)

    grouped_cards(initial_hand).each do |suite, cards| 
      if suite == flush_suite
        @bottom.concat cards
      else
        cards.each do |card|
          if put_in_middle? card
            @middle << card
          elsif @top.count < 3
            @top << card
          elsif @middle.count < 5
            @middle << card
          elsif @bottom.count < 5
            @bottom << card
          else
            raise 'You gave me too many cards jackass!'
          end
        end
      end
    end
  end

  protected
  def grouped_cards(initial_hand)
    initial_hand.group_by {|card| suite(card)}
  end

  def most_popular_suite(hand)
    grouped_cards(hand).max_by {|suite, cards| cards.count}.try :first
  end

  def suite(card)
    Hand::SUITES[card[-1]]
  end
end
