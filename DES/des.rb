require 'pry'

class Des

def initialize(plainText="Prueba")
   puts plainText
end

def enipherment
   # First it has to do the 'Initial Permutation'
   # Then the 16 rounds
      # On each round it recieves a different key
   # The next step is the '32-bit Swap'
   # Finally it has to do the 'Inverse Initial Permutation'

end

def desRound

end

def initialPermutation

end

end

a = Des.new()
