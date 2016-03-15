require 'pry'
require_relative "s-box"
# TODO If the plainText is greater than 64 bits it has to run this two times, but running each 64-bit
# blocks again... If there is a shorter block (less than 64-bit), then it has to add 0's to the
# beggining of the block
class Des

def initialize(plainText="HOLAMUND")
   plainBinText = getBin(plainText)
   creatingSBoxes
   cipherText = encipherment(plainBinText)
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
   i = 0
   while i < 16
      roundResult = round(rightArr)
      tempLeft = leftArr
      leftArr = rightArr
      rightArr = xORRound(roundResult, tempLeft)
      i += 1
   end

      swapArray = lastSwap(leftArr, rightArr)
      cipherTextBin = finalPermutation(swapArray)
      binding.pry
      cipherText = fromBinToAscii(cipherTextBin)
      return cipherText


   # TODO hace falta 32-bit Swap

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
# This method does the initial permutation
def initialPermutation(plainBinText)

   matrizIP = Array.new()
   # Top Half done with the following block of code
   j = 0
   i = 1
   while i < 8
      matrizFila = Array.new()
      while j < 8
         matrizFila.unshift(plainBinText[j][i])
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
         matrizFila.unshift(plainBinText[j][i])
         j += 1
      end
      matrizIP.push(matrizFila)
      j = 0
      i += 2
   end
   return matrizIP
end

def lastSwap(leftArr, rightArr)
   swapArray = Array.new()
   blockSwapArray = Array.new()
   # TODO Preguntar acerca de orden!!
   rightArr.each { |e| swapArray.push(e) }
   leftArr.each { |e| swapArray.push(e) }

   i = 0
   k = 7
   j = 0
   while j < 8
      filaArray = Array.new()
      filaArray = swapArray[i..k]
      i += 8
      k += 8
      blockSwapArray.push(filaArray)
      j += 1
   end
   return blockSwapArray
end

def finalPermutation(swapArray)

   matrizFP = Array.new()
   # Top Half to odd columns (considering it'll begin with 0 and NOT with 1)
   j = 0
   i = 7
   k = 0
   top = true
   while i > -1
      matrizFila = Array.new()
      while j < 8
         matrizFila.push(swapArray[j][i])
         if top == true
            j += 4
            top = false
         elsif top == false
            j -= 3
            top = true
            k += 1
         elsif j == 7

         end

      end
      matrizFP.push(matrizFila)
      i -= 1
      j = 0
      top = true
   end
   i = 0
   while i < 8
      matrizFP[i].delete_at(-1)
      i += 1
   end
   return matrizFP
end

def fromBinToAscii(binArray)
   binString = ""
   i = 0
   # while i <  8
   #    j = 0
   #    while j < 8
   #       binString = binString + binArray[i][j].to_s
   #       j += 1
   #    end
   #    i += 1
   # end

   # i = 0
   # while i < 8
   #    binString[i, 8].to_i
   # end

i = 0
newArray = Array.new()
# TODO Se necesita convertir de binario a Ascii y se termina!!! ""
while i < 8
   newArray.push(convertIntArrToStrArr(binArray[i]))
i += 1
end
   c = newArray[0].pack('C')
   binding.pry

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
# This method calls every method of a round
def round (rightArr)
   expandedArray = expansion(rightArr)
   xORArray = xORRound(expandedArray, expandedArray) # Se necesita cambiar el segundo parámetro por la llave
   substitutionArray = substitution(xORArray)
   permutedArray = permutation(substitutionArray)
   return permutedArray
end
# Expansion Permutation method
def expansion(rightArr)
   expandedArray = Array.new()
   i = 0 # Column
   j = 5
   expandedArray.push(rightArr[rightArr.length-1])
   while j < 34
      while i < j
         expandedArray.push(rightArr[i])
         i += 1
      end
      i -= 2
      j += 4
   end
   # It use the first bit and put it at the last position of the array
   expandedArray.push(rightArr[0])
   expandedArray.delete_at(-2)
   return expandedArray
end
# This method realizes the XOR function over the expandedArray and the key; both with 48 bits
def xORRound (expandedArray, keyBitArr)
   xORArray = Array.new(expandedArray.length)
   # First it has to change the array of String values to Integers
   expandedArray = convertStrArrToIntArr(expandedArray)
   keyBitArr = convertStrArrToIntArr(keyBitArr)
   i = 0
   while i < expandedArray.length
      xORArray[i] = expandedArray[i]^keyBitArr[i]
      i += 1
   end
   return xORArray
end

def substitution(xORArray)
   bitsBlock = 1 # From 1 to 8 (bitsBlock < 9)
   xORArray = convertIntArrToStrArr(xORArray)
   substitutionArray = ""
   i = 0
   j = 5
   while bitsBlock < 9
      sixArray = xORArray[i..j]
      outerBits = sixArray[0]+sixArray[sixArray.length-1]
      innerBits = ""
      a=1
      while a < 5
         innerBits = innerBits + sixArray[a]
         a+=1
      end
      outerBits = outerBits.to_i(2)
      innerBits = innerBits.to_i(2)
      # outerBits = "10".to_i(2) Pruebas
      # innerBits = "0111".to_i(2) Pruebas
      case bitsBlock
      when 1
         selectedCell = @sB1[outerBits][innerBits]
      when 2
         selectedCell = @sB2[outerBits][innerBits]
      when 3
         selectedCell = @sB3[outerBits][innerBits]
      when 4
         selectedCell = @sB4[outerBits][innerBits]
      when 5
         selectedCell = @sB5[outerBits][innerBits]
      when 6
         selectedCell = @sB6[outerBits][innerBits]
      when 7
         selectedCell = @sB7[outerBits][innerBits]
      when 8
         selectedCell = @sB8[outerBits][innerBits]
      end
      i += 6
      j += 6
      bitsBlock += 1
      substitutionArray = substitutionArray + selectedCell
   end
   # This method returns a string, but to keep with the array model used, it has to pass
   # each char to a new array. The following metho does the trick. (fromStrToArray)
   substitutionArray = fromStrToArray(substitutionArray)
   return substitutionArray
end
def permutation(substitutionArray)
   orderArray = [16, 7, 20, 21, 29, 12, 28, 17, 1, 15, 23, 26, 5, 18, 31, 10, 2, 8, 24, 14, 32, 27, 3, 9, 19, 13, 30, 6, 22, 11, 4, 25]
   permutedArray = Array.new()
   i = 0
   while i < orderArray.length
      j = orderArray[i]-1
      permutedArray.push(substitutionArray[j])
      i += 1
   end
   return permutedArray
end

def fromStrToArray(string)
   newArray = Array.new()
   string.each_char { |chr| newArray.push(chr) }
   return newArray
end
def creatingSBoxes
   sBox = SBox.new()
   @sB1 = sBox.getSB1
   @sB2 = sBox.getSB2
   @sB3 = sBox.getSB3
   @sB4 = sBox.getSB4
   @sB5 = sBox.getSB5
   @sB6 = sBox.getSB6
   @sB7 = sBox.getSB7
   @sB8 = sBox.getSB8
end

# This method convert an array of string to an array of integers
def convertStrArrToIntArr (arrayToConvert)
   arrayConverted = Array.new(arrayToConvert.length)
   i = 0
   while i < arrayToConvert.length
      arrayConverted[i] = arrayToConvert[i].to_i
      i += 1
   end
   return arrayConverted
end

# This method convert an array of string to an array of integers
def convertIntArrToStrArr (arrayToConvert)
   arrayConverted = Array.new(arrayToConvert.length)
   i = 0
   while i < arrayToConvert.length
      arrayConverted[i] = arrayToConvert[i].to_s
      i += 1
   end
   return arrayConverted
end

end

a = Des.new()
