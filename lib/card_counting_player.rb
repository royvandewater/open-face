require_relative 'player'
require 'active_support/core_ext/enumerable' # provides sum
require 'ofcp_card_counter'

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
    card_counter = OfcpCardCounter::CardCounter.new(
      :turns_left => turns_left,
      :cards      => all_cards
    )
    card_counter.probability_of_getting number, options
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

  def turns_left
    13 - cards.count
  end
end
