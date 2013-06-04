require 'active_support/core_ext/object' # provides try and other goodies :-)
require_relative 'hand'

class DumbPlayer
  attr_reader :name, :score

  def initialize(options={})
    @name = options[:name]
    @bottom_cuttoff = options[:bottom_cuttoff] || 10
    @middle_cuttoff = options[:middle_cuttoff] || 12
    @top    = Hand.new :size => 3
    @middle = Hand.new :size => 5
    @bottom = Hand.new :size => 5
    @score  = 0
  end

  def add_points(points)
    @score += points
  end

  def hands
    [@top, @middle, @bottom]
  end

  def misset
    not set
  end

  def put_in_bottom?(card)
    return false if @bottom.count >= 5
    value_of(card) >= @bottom_cuttoff
  end

  def put_in_middle?(card)
    return false if @middle.count >= 5
    value_of(card) >= @middle_cuttoff
  end

  def set
    hands.sort == hands
  end

  def start(initial_hand)
    initial_hand.each do |card|
      take card
    end
  end

  def take(card)
    if put_in_bottom? card
      @bottom << card
    elsif put_in_middle? card
      @middle << card
    elsif @top.count < 3
      @top << card
    elsif @middle.count < 5
      @middle << card
    else
      @bottom << card
    end
  end

  def to_s
    @name.try(:to_s) || self
  end

  def value_of(card)
    value = card[0..-2]
    return value.to_i if value[/^[0-9]+$/]

    case value
    when 'J' then 11
    when 'Q' then 12
    when 'K' then 13
    when 'A' then 14
    end
  end
end
