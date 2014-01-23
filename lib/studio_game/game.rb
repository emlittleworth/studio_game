require_relative 'player'
require_relative 'die'
require_relative 'game_turn'
require_relative 'treasure_trove'

module StudioGame
    class Game
        attr_reader :title

        def initialize(title)
            @title = title
            @players = []
        end

        def add_player(playa)
            @players << playa
        end

        def load_players(filename)
            File.readlines(filename).each do |line|
                add_player(Player.from_csv(line))
            end
        end

        def play(rounds)
            puts "There are #{@players.size} players in #{@title}:"

            @players.each do |playa|
                puts playa
            end
            
            1.upto(rounds) do |round|
                puts "\nRound #{round}:"
                @players.each do |playa|
                    GameTurn.take_turn(playa)
                    puts playa
                end
            end

            treasures = TreasureTrove::TREASURES
            puts "\nThere are #{treasures.size} treasures to be found:"
            treasures.each do |treasa|
                puts "A #{treasa.name} is worth #{treasa.points} points"
            end

        end

        def print_name_and_health(playa)
            puts "#{playa.name} (#{playa.health})"
        end

        def print_stats
            strong_players, wimpy_players = @players.partition {|playa| playa.strong?}
            puts "\n#{@title} Statistics:"
            
            puts "\n#{strong_players.length} strong players:"
            strong_players.each do |playa|
                puts "#{playa.name} (#{playa.health})"
            end

            puts "\n#{wimpy_players.length} wimpy players:"
            wimpy_players.each do |playa|
                print_name_and_health(playa)
            end

            puts "\n#{@title} High Scores:"
            @players.sort.each do |playa|
                puts high_score_entry(playa)
            end
            
            @players.sort.each do |playa|
                puts "\n#{playa.name}'s point totals:"
                playa.each_found_treasure do |treasure|
                    puts "#{treasure.points} total #{treasure.name} points"
                end
                puts "#{playa.points} grand total points"
            end
        end

        def save_high_scores(filename = 'high_scores.txt')
            File.open(filename, 'w') do |file|
                file.puts "#{@title} High Scores:"
                @players.sort.each do |player|
                    file.puts high_score_entry(player)
                end
            end
        end

        def high_score_entry(player)
                formatted_name = player.name.ljust(20, '.')
                "#{formatted_name} #{player.score}"
        end
    end
end
