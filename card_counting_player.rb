require_relative 'player'
require 'active_support/core_ext/enumerable' # provides sum

class CardCountingPlayer < Player
  def probability_of_getting(number, options={})
    return 1.0 if number <= 0 || options[:of].nil?

    targets = options[:of] - all_cards
    targets_left = targets.count.to_f
    chances_left = (options[:chances_left] || 13 - cards.count).to_f
    cards_left   = (options[:cards_left]   || 52 - cards.count).to_f

    return 0.0 if chances_left < number

    successful_case  = targets_left / cards_left
    successful_case *= probability_of_getting (number - 1), :of => targets[1..-1], :cards_left => (cards_left - 1), :chances_left => (chances_left - 1)

    unsuccessful_case  = (cards_left - targets_left) / cards_left
    unsuccessful_case *= probability_of_getting number, :of => targets, :cards_left => (cards_left - 1), :chances_left => (chances_left - 1)

    successful_case + unsuccessful_case
  end

  def probability_of_getting_a(card)
    probability_of_getting 1, :of => [card]
  end

  def all_cards
    return cards if other_players.empty?

    cards + other_players.sum do |player|
      player.hands.sum &:cards
    end
  end

  def cards
    hands.sum &:cards
  end

  def put_in_bottom?(card)
  end

  def put_in_middle?(card)
  end
end



