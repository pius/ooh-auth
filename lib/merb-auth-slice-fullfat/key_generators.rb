# MerbAuthSliceFullfat::KeyGenerators
# ==========================================
# A set of generators for common password types.
# Usage:
# MerbAuthSliceFullfat::KeyGenerators::<type>.new(length_if_applicable)
# where <type> is any of:
# Password: a memorable password such as 254yellowShoes or 869spaceageBiplanes
# Passphrase: a memorable passphrase made up of [length] words.
# Alphanum: a gibberish string [length] characters long.

module MerbAuthSliceFullfat
  module KeyGenerators
    
    ALPHANUM =    (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).freeze
                  # Want to make an absurdly easy contribution to open source software? Think of more adjectives and nouns that don't
                  # result in potentially offensive combinations. but DO result in a wider password namespace.
                  # In particular, avoid adjectives like moist, gristly, or veiny.
                  # and avoid nouns like penis.
    ADJECTIVES =  %w(blue green red orange purple grey yellow scarlet flying edible tasty noisy giant tiny angry great terrific
                     improvised tiny magnificent futuristic anachronistic cromulent fashionable trendy spaceage vintage classic
                     speedy slow loud quiet
                  ).freeze                  
    NOUNS =       %w(ninjas nostrils suitcases earlobes houses cakes pies shoes dinosaurs robots androids antelope bees 
                    insects chickens apples guitars trombones baloons suitcases pineapples cheeses teeth mice castles
                    monsters bicycles kippers turtles bongos words phrases tables desks couches biplanes beans neighbours
                    telephones yetis sentries cupboards
                  ).freeze
    
    # A memorable password based on the pattern XXadjectiveNouns, for example 67blueTeeth or 267noisySandboxes.
    class Password < String
      def self.new(len=0)
        super "#{rand(999)}#{ADJECTIVES[rand(ADJECTIVES.length)]}#{NOUNS[rand(NOUNS.length)].capitalize}"
      end
    end
  
    # A multi-word passphrase based on the dictionary, containing spaces.
    class Passphrase < String
      def self.new(len=3)
        p = []
        len.times do |i|
          pool = NOUNS.select {|w| !p.include?(w)}
          p << pool[rand(pool.length)]
        end
        super p.join(" ")
      end
    end
  
    # A good ol' fashioned incomprehensible string of alphanumeric characters.
    class Alphanum < String
      def self.new(len=18)
        super((0..(len-1)).collect {|x| ALPHANUM[rand(ALPHANUM.length)] }.join(""))
      end
    end
    
    
  end # module KeyGenerators
end # module MerbAuthSliceFullfat