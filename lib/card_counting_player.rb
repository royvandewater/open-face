require_relative 'player'
require 'active_support/core_ext/enumerable' # provides sum

class CardCountingPlayer < Player
  SUITES = %w{H D S C}
  def put_in_bottom?(card)
  end

  def put_in_middle?(card)
  end

  def probability_of_a_two_of_a_kind(row)
    hand = hand_for row
    probability_of_getting 1, :of => all_suites(hand)
  end

  def probability_of_getting(number, options={})
    return 1.0 if number <= 0 || options[:of].nil?

    targets = options[:of] - all_cards
    targets_left = targets.count.to_f
    chances_left = (options[:chances_left] || 13 - cards.count).to_f
    cards_left   = (options[:cards_left]   || 52 - all_cards.count).to_f

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

  protected
  def all_cards
    return cards if other_players.empty?

    cards + other_players.sum do |player|
      player.hands.sum &:cards
    end
  end

  def all_suites(cards)
    cards.map do |card|
      face_value = card[0..-2]
      SUITES.map do |suite|
        "#{face_value}#{suite}"
      end
    end.flatten
  end

  def cards
    hands.sum &:cards
  end

  def hand_for(row)
    case row
    when :top then @top
    when :middle then @middle
    when :bottom then @bottom
    else raise 'not a valid row type'
    end
  end
end
