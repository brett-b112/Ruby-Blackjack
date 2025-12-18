class Card
# Playing card class that contains the suit and value of the card

  attr_reader :suit

  def initialize(suit, value)
    @suit = suit
    @value = value
  end 

  def value
    return 11 if @value == "Ace"
    return 10 if %w[Jack Queen King].include?(@value)
    @value.to_i
  end

  def ace?
    @value == "Ace"
  end

    def to_s
    "#{@value} of #{@suit}"
  end

end