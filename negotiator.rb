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

    points += @player1.hands.first  <=> @player2.hands.first
    points += @player1.hands.second <=> @player2.hands.second
    points += @player1.hands.third  <=> @player2.hands.third

    points *= 2 if points.abs == 3
    points
  end

  def points_for_player2
    -1 * points_for_player1
  end
end
