require_relative 'player'

class DumbPlayer < Player
  def put_in_bottom?(card)
    return false if @bottom.count >= 5

    if @bottom.suites.count == 1 and @bottom.suites.include? suite(card)
      true
    else
      value_of(card) >= 9
    end
  end

  def put_in_middle?(card)
    return false if @middle.count >= 5
    value_of(card) > 3
  end

  def take_initial(initial_hand)
    return @bottom.concat initial_hand if Hand.new(:cards => initial_hand).full_house
    return flush_it_up initial_hand    if most_popular_suite_cards(initial_hand).count >= 3
    return straight_it_up initial_hand if longest_run(initial_hand).count >= 3
  end

  protected
  def default_take(card)
    if put_in_middle? card
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

  def flush_it_up(cards)
    @bottom.concat most_popular_suite_cards(cards)

    remaining_cards = cards - @bottom.cards
    remaining_cards.each do |card|
      default_take card
    end
  end

  def grouped_cards(initial_hand)
    initial_hand.group_by {|card| suite(card)}
  end

  def most_popular_suite_cards(hand)
    grouped_cards(hand).max_by {|suite, cards| cards.count}.try :last
  end

  def longest_run(initial_hand)
    cards = Hand.new(:cards => initial_hand).sort!.cards

    runs = []
    cards.each do |card|
      run = runs.last

      if run.nil?
        runs << [card]
      elsif value_of(card) - value_of(run.last) == 1
        run << card
      else
        runs << [card]
      end
    end

    runs.max_by do |run|
      run.count
    end
  end

  def straight_it_up(initial_hand)
    @bottom.concat longest_run(initial_hand)
    remaining_cards = initial_hand - @bottom.cards
    remaining_cards.each do |card|
      default_take card
    end
  end

  def suite(card)
    Hand::SUITES[card[-1]]
  end
end
