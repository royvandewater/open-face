require 'active_support/core_ext/object' # provides try and other goodies :-)
require_relative 'hand'

class Player
  SUITES = {'H' => :hearts, 'C' => :clubs, 'D' => :diamonds, 'S' => :spades}
  
  attr_reader :name, :score

  def initialize(options={})
    @name = options[:name]
    @score  = 0
    initialize_hands
  end

  def add_points(points)
    @score += points
  end

  def hands
    [@top, @middle, @bottom]
  end

  def initialize_hands
    @top    = Hand.new :size => 3
    @middle = Hand.new :size => 5
    @bottom = Hand.new :size => 5
  end

  def misset
    not set
  end

  def set
    hands.sort == hands
  end

  def start(initial_hand)
    initialize_hands

    take_initial initial_hand
  end

  def take_initial(initial_hand)
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
    elsif @bottom.count < 5
      @bottom << card
    else
      raise 'You gave me too many cards jackass!'
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
