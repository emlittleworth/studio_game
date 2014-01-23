require_relative 'player'
require_relative 'die'
require_relative 'treasure_trove'
require_relative 'loaded_die'

module StudioGame
    module GameTurn
        def self.take_turn(playa)
                die = Die.new
                case die.roll
                when 1..2
                    playa.blam
                when 3..4
                    puts "#{playa.name} was skipped."
                else
                    playa.w00t
                end
                
                treasure = TreasureTrove.random
                playa.found_treasure(treasure)

        end
    end
end
