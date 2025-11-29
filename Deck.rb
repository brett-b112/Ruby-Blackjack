require_relative "card" 

class Deck
  # Creates a deck of cards
  VALUES = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"].freeze
  SUITS = ["Spades", "Diamonds", "Clubs", "Hearts"].freeze

  # Deck containing 52 cards of four suits
  attr_reader :deck

  def initialize
    @deck= build_deck.shuffle
  end 

  def build_deck 
    SUITS.flat_map do |suit|
      VALUES.map { |value| Card.new(value, suit) }
    end
  end

end 
  
