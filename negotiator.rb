class Negotiator
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def negotiate!
    @player1.add_points points_for_player1
    @player2.add_points points_for_player2
  end

  private
  def bottom_hand_points
    
  end

  def hand_points(hand1, hand2)
    points = hand1 <=> hand2

    if points == 1
      points += hand_royalties(hand1)
    elsif points == -1
      points -= hand_royalties(hand2)
    end

    points
  end

  def hand_royalties(hand)
    return 25 if hand.royal_flush
    return 15 if hand.straight_flush
    return 10 if hand.four_of_a_kind
    return 6 if hand.full_house
    return 4 if hand.flush
    return 2 if hand.straight
    0
  end

  def points_for_player1
    points = 0

    points += hand_points @player1.hands.first, @player2.hands.first
    points += hand_points @player1.hands.second, @player2.hands.second
    points += hand_points @player1.hands.third, @player2.hands.third

    points += scoop_points
    points
  end

  def points_for_player2
    -1 * points_for_player1
  end

  def scoop_points
    points = 0
    points += @player1.hands.first <=> @player2.hands.first
    points += @player1.hands.second <=> @player2.hands.second
    points += @player1.hands.third <=> @player2.hands.third

    points.abs == 3 ? points : 0
  end
end
