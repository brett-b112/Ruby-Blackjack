require_relative 'card.rb'
require_relative 'dealer.rb'
require_relative 'deck.rb'
require_relative 'player.rb'

def print_banner
  puts "\n" + "=" * 60
  puts "    ♠♥♣♦  WELCOME TO BLACKJACK SIMULATION  ♦♣♥♠"
  puts "=" * 60 + "\n"
end

def print_section_header(title)
  puts "\n" + "-" * 60
  puts "  #{title}"
  puts "-" * 60
end

def card_visual(card)
  suit_symbols = {
    "Spades" => "♠",
    "Hearts" => "♥",
    "Diamonds" => "♦",
    "Clubs" => "♣"
  }

  value_display = card.display_value
  suit_symbol = suit_symbols[card.suit]

  "[#{value_display}#{suit_symbol}]"
end

def pause(seconds = 1)
  sleep(seconds)
end

def select_players
# User selects the number of players that they want to play with
# This inherently selects the number of decks to obscure card counting
    print "  Enter how many players you want at the table besides yourself (0 - 5): "
    while true
        begin
            players = Integer(gets.chomp)
            if players >= 0 && players <= 5
                break
            else
                puts "  Please enter an integer 0 - 5."
                print "  Enter how many players you want at the table besides yourself (0 - 5): "
            end
        rescue ArgumentError
            puts "  Please enter an integer"
            print "  Enter how many players you want at the table besides yourself (0 - 5): "
        end
    end
    puts "\n  ✓ Table set! You are playing with #{players} other player#{'s' if players != 1}."
    players
end 


def generate_atmosphere
  # Generate the stack of decks
  num_a = select_players + 1

  decks = []
  players = []

  print "  Shuffling #{num_a} deck#{'s' if num_a != 1}..."
  pause(0.5)

  num_a.times do
    decks << Deck.new
  end

  num_a.times do
    players << Player.new
  end

  puts " Done! ✓"
  pause(0.5)

  return players, decks
end

def build_shoe(decks)
  puts "  Building the shoe from #{decks.length} deck#{'s' if decks.length != 1}..."
  pause(0.5)
  shoe = decks.flat_map(&:deck).shuffle
  puts "  Shoe ready with #{shoe.length} cards! ✓\n"
  pause(0.5)
  shoe
end

def deal_initial_cards(players, dealer, shoe)
  print_section_header("DEALING INITIAL CARDS")

  puts "  Dealing first card to each player..."
  pause(0.8)
  players.each { |player| player.hit(shoe.pop) }
  dealer.hit(shoe.pop)

  puts "  Dealing second card to each player..."
  pause(0.8)
  players.each { |player| player.hit(shoe.pop) }
  dealer.hit(shoe.pop)

  puts "\n  🎴 INITIAL HANDS 🎴\n\n"
  pause(0.5)

  players.each_with_index do |player, i|
    player.hands.each_with_index do |hand, j|
      cards_visual = hand.map { |card| card_visual(card) }.join(" ")
      total = player.update_total(j)
      puts "  Player #{i + 1}: #{cards_visual}  (Total: #{total})"
      pause(0.3)
    end
  end

  dealer_hand = dealer.hands[0]
  dealer_visual = card_visual(dealer_hand[0]) + " [??]"
  puts "\n  Dealer:    #{dealer_visual}  (Showing: #{dealer_hand[0].value})"
  pause(0.5)
end


def player_turn(player, player_num, shoe)
  hand_index = player.current_hand

  while !player.stand_status[hand_index] && !player.bust_status[hand_index]
    total = player.update_total(hand_index)
    hand = player.hands[hand_index]
    cards_visual = hand.map { |card| card_visual(card) }.join(" ")

    if total < 17
      new_card = shoe.pop
      print "    → Player #{player_num} hits... "
      pause(0.8)
      player.hit(new_card)
      new_total = player.update_total(hand_index)

      puts "drew #{card_visual(new_card)}"
      puts "      Hand: #{cards_visual} #{card_visual(new_card)}  (Total: #{new_total})"

      if player.bust_status[hand_index]
        puts "      💥 BUST! Over 21!"
      end
      pause(0.6)
    else
      puts "    → Player #{player_num} stands with #{total}"
      player.stand
      pause(0.5)
    end
  end
end

def determine_winners(players, dealer)
  print_section_header("FINAL RESULTS")

  dealer_total = dealer.update_total(0)
  dealer_hand = dealer.hands[0]
  dealer_visual = dealer_hand.map { |card| card_visual(card) }.join(" ")

  puts "\n  Dealer's Final Hand: #{dealer_visual}  (Total: #{dealer_total})"
  if dealer_total > 21
    puts "  💥 Dealer BUSTS!"
  end
  puts ""
  pause(1)

  wins = 0
  losses = 0
  pushes = 0

  players.each_with_index do |player, i|
    player_total = player.update_total(player.current_hand)
    player_hand = player.hands[player.current_hand]
    player_visual = player_hand.map { |card| card_visual(card) }.join(" ")

    print "  Player #{i+1}: #{player_visual}  (Total: #{player_total}) → "
    pause(0.5)

    if player_total > 21
      puts "❌ BUST"
      losses += 1
    elsif dealer_total > 21 || player_total > dealer_total
      puts "✅ WINS!"
      wins += 1
    elsif player_total < dealer_total
      puts "❌ LOSES"
      losses += 1
    else
      puts "🤝 PUSH (Tie)"
      pushes += 1
    end
    pause(0.4)
  end

  puts "\n" + "=" * 60
  puts "  SUMMARY: #{wins} Win#{'s' if wins != 1} | #{losses} Loss#{'es' if losses != 1} | #{pushes} Push#{'es' if pushes != 1}"
  puts "=" * 60 + "\n"
end


def main
    print_banner
    print_section_header("TABLE SETUP")

    dealer = Dealer.new
    players, decks = generate_atmosphere
    shoe = build_shoe(decks)

    deal_initial_cards(players, dealer, shoe)

    print_section_header("PLAYERS' TURNS")
    pause(0.5)

    players.each_with_index do |player, i|
      puts "\n  Player #{i + 1}'s Turn:"
      pause(0.3)
      player_turn(player, i + 1, shoe)
    end

    print_section_header("DEALER'S TURN")
    pause(0.5)

    dealer_hand = dealer.hands[0]
    dealer_visual = dealer_hand.map { |card| card_visual(card) }.join(" ")
    dealer_total = dealer.update_total(0)
    puts "\n  Dealer reveals: #{dealer_visual}  (Total: #{dealer_total})"
    pause(1)

    if dealer_total < 17
      puts "  Dealer must hit on totals under 17...\n"
      pause(0.8)
    end

    while dealer_total < 17 && !dealer.bust_status[0]
      new_card = shoe.pop
      print "    → Dealer hits... "
      pause(0.8)
      dealer.hit(new_card)
      dealer_total = dealer.update_total(0)
      dealer_hand = dealer.hands[0]
      dealer_visual = dealer_hand.map { |card| card_visual(card) }.join(" ")

      puts "drew #{card_visual(new_card)}"
      puts "      Hand: #{dealer_visual}  (Total: #{dealer_total})"

      if dealer.bust_status[0]
        puts "      💥 Dealer BUSTS!"
      end
      pause(0.8)
    end

    if dealer_total >= 17 && dealer_total <= 21
      puts "\n  Dealer stands with #{dealer_total}"
      dealer.stand
    end
    pause(1)

    determine_winners(players, dealer)
end

main
