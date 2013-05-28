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
    @player1.hands.last > @player2.hands.last ? 6 : 1
  end

  def points_for_player2
    -1 * points_for_player1
  end
end
