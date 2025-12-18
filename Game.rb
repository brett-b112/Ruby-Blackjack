require_relative 'card.rb'
require_relative 'dealer.rb'
require_relative 'deck.rb'
require_relative 'player.rb'

def select_players
# User selects the number of players that they want to play with 
# This inherently selects the number of decks to obscure card counting
    print "Enter how many players you want at the table besides yourself (0 - 5): "
    while true
        begin
            players = Integer(gets.chomp)
            if players >= 0 && players <= 5
                break 
            else 
                puts "Please enter an integer 0 - 5. \n"
                print "Enter how many players you want at the table besides yourself (0 - 5): "
            end
        rescue ArgumentError
            puts "Please enter an integer \n"
            print "Enter how many players you want at the table besides yourself (0 - 5): "
        end 
    end 
    puts "You are sitting at a table with #{players} players."
    players
end 


def generate_atmosphere
  # Generate the stack of decks
  num_a = select_players + 1

  decks = []
  players = []

  num_a.times do
    decks << Deck.new
  end

  num_a.times do
    players << Player.new
  end

  return players, decks
end

def build_shoe(decks)
  decks.flat_map(&:deck).shuffle
end

def deal_initial_cards(players, dealer, shoe)
  2.times do
    players.each { |player| player.hit(shoe.pop) }
    dealer.hit(shoe.pop)
  end

  players.each_with_index do |player, i|
    puts "Player #{i + 1}:"

    player.hands.each_with_index do |hand, j|
      cards = hand.map(&:to_s).join(", ")
      puts "  Hand #{j + 1}: #{cards}"
    end
  
  end

end

def main
    dealer = Dealer.new 
    players, decks = generate_atmosphere 
    shoe = build_shoe(decks)
    deal_initial_cards(players, dealer, shoe)
end 

main
