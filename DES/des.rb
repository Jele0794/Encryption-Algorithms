require 'pry'
# TODO If the plainText is greater than 64 bits it has to run this two times, but running each 64-bit
# blocks again... If there is a shorter block (less than 64-bit), then it has to add 0's to the
# beggining of the block
class Des

def initialize(plainText="01234567")
   plainBinText = getBin(plainText)
   encipherment(plainBinText)
end

def encipherment(plainBinText)
   # First it has to do the 'Initial Permutation'
   # Then the 16 rounds
      # On each round it recieves a different key
   # The next step is the '32-bit Swap'
   # Finally it has to do the 'Inverse Initial Permutation'

   iPResult = initialPermutation(plainBinText)
   twoHalvesArr = divideInTwo(iPResult)
   leftArr = twoHalvesArr[0]
   rightArr = twoHalvesArr[1]
   round(rightArr)

   return true

end

# This method will obtain the Hex number of a char (Ascii)
def getBin(plainText)
   matriz = Array.new()
   plainBinTextArr = plainText.unpack('B64')
   plainBinText = Array.new()
   plainBinTextArr[0].each_char { |chr| plainBinText.push(chr)}

   i = 0
   j = 0
   # Con este while se planea llenar la matriz "matriz"
   while i < 8
      # Se inserta en la posición i el segmento de 8 elementos
      # desde la posición j de la matriz "plainBinText".
      matriz.insert(i, plainBinText[j, 8])
      i += 1
      j = j+8
   end
   return matriz
end
# This methos does the initial permutation
def initialPermutation(plainBinText)
   matrizIP = Array.new()
   # Top Half done with the following block of code
   j = 0
   i = 1
   while i < 8
      matrizFila = Array.new()
      while j < 8
         matrizFila.push(plainBinText[j][i])
         j += 1
      end
      matrizIP.push(matrizFila)
      j = 0
      i += 2
   end
   # Bottom Half done with the following block of code
   i=0
   while i < 7
      matrizFila = Array.new()
      while j < 8
         matrizFila.push(plainBinText[j][i])
         j += 1
      end
      matrizIP.push(matrizFila)
      j = 0
      i += 2
   end
   return matrizIP
end
# This methos divides the full block in two halves
def divideInTwo(iPResult)
   i = 0
   rightArr = Array.new()
   leftArr = Array.new()
   while i < 4
      iPResult[i].each { |e| rightArr.push(e) }
      i += 1
   end
   while i < 8
      iPResult[i].each { |e| leftArr.push(e) }
      i += 1
   end
   wholeArr = Array.new()
   wholeArr.push(rightArr)
   wholeArr.push(leftArr)
   return wholeArr
end
# This method has TODO the whole round
def round (rightArr)
   expandedArray = expansion(rightArr)


end
# Expansion Permutation method
def expansion(rightArr)
   expandedArray = Array.new()
   i = 0 # Column
   # TODO
   # Three cases:
   # If the first position of the set is 0, it has to add the last number of the array to the beggining
   if i == 0
      

   # If the last position of the set is the (length-1), it has to add the first number of the array to the last position (push)
   elsif i == rightArr.length-1


   # Else, it has to add the number of the previous position at the beggining and the number of the following position to the end
   else

   end



   return expandedArray

end

end

a = Des.new()
