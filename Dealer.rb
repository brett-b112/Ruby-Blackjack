require_relative "player"
require_relative "card"
require_relative "deck"

class Dealer < Player
  def initialize
    super
  end

  def auto_play(deck)
    # Dealer hits until reaching 17 or higher.
    until update_total(@current_hand) >= 17
      hit(deck.draw)
    end
    stand
  end

  def split
    # Dealers do not split.
    puts "Dealer cannot split."
  end
end

