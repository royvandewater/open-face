require 'active_support/core_ext/array' # provides second and other goodies :-)
require_relative 'hand'

class CardHolder
  def initialize(hands)
    @top    = Hand.new :size => 3, :cards => hands.first
    @middle = Hand.new :size => 5, :cards => hands.second
    @bottom = Hand.new :size => 5, :cards => hands.third
  end

  def hands
    [@top, @middle, @bottom]
  end

  def misset
    not set
  end

  def set
    hands.sort == hands
  end
end
