class Negotiator
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def negotiate!
    @player1.add_points 6
    @player2.add_points -6
  end
end
