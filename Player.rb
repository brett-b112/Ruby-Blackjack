require_relative "card"

class Player
  # Player class that holds the individual player
  attr_accessor :hands, :stand_status, :bust_status, :current_hand 

  def initialize
    #Intializer variables
    @hands= [ [] ]
    @stand_status = [false]
    @bust_status = [false]
    @current_hand = 0
  end 

def update_total(hand_index)
  hand = @hands[hand_index]

  total = hand.sum(&:value)
  aces  = hand.count(&:ace?)

  while total > 21 && aces > 0
    total -= 10
    aces -= 1
  end

  total
end


  def hit(card)
    # Player recieves a card
    return if @stand_status[@current_hand] || @bust_status[@current_hand]

    @hands[@current_hand] << card

    if update_total(@current_hand) > 21
      @bust_status[@current_hand] = true
    end
  end

  def stand
    # Player stops receiving cards
    @stand_status[@current_hand] = true
  end 

  def split
    # must have exactly two cards & matching value, and only one hand
    if @hands.length == 1 &&
       @hands[0].length == 2 &&
       @hands[0][0].value == @hands[0][1].value

      card1 = @hands[0][0]
      card2 = @hands[0][1]

      @hands = [[card1], [card2]]
      @stand_status = [false, false]
      @bust_status = [false, false]

      puts "Player split into two hands!"
    else
      puts "Split not allowed"
    end
  end
end