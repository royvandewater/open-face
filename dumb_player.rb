require_relative 'player'

class DumbPlayer < Player
  def initialize(options={})
    super
    @bottom_cuttoff = options[:bottom_cuttoff] || 10
    @middle_cuttoff = options[:middle_cuttoff] || 5
  end

  def put_in_bottom?(card)
    return false if @bottom.count >= 5
    value_of(card) >= @bottom_cuttoff
  end

  def put_in_middle?(card)
    return false if @middle.count >= 5
    value_of(card) >= @middle_cuttoff
  end
end
