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
  def points_for_player1
    points = 0

    points += @player1.hands.first <=> @player2.hands.first
    points += @player1.hands.second <=> @player2.hands.second
    points += bottom_hand_points

    points += scoop_points
    points
  end

  def points_for_player2
    -1 * points_for_player1
  end

  def bottom_hand_points
    hand1, hand2 = @player1.hands.third, @player2.hands.third
    points = hand1 <=> hand2

    if points == 1
      points += 6 if hand1.full_house
      points += 2 if hand1.straight
    elsif points == -1
      points -= 6 if hand2.full_house
      points -= 2 if hand2.straight
    end

    points
  end

  def scoop_points
    points  = @player1.hands.first <=> @player2.hands.first
    points += @player1.hands.second <=> @player2.hands.second
    points += @player1.hands.third <=> @player2.hands.third

    points.abs == 3 ? points : 0
  end
end
