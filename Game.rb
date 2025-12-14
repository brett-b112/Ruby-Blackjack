require_relative 'card.rb'
require_relative 'dealer.rb'
require_relative 'deck.rb'
require_relative 'player.rb'



def select_players
# User selects the number of players that they want to play with 
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
    return players
end 


select_players