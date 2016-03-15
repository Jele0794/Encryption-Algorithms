require 'pry'
require_relative 's-box'
require_relative 'des'
class DesDecipher
   def initialize(cipherText = "c8bd1ff9ddf759ea")
      @des = Des.new()
      @wholeArray = @des.getwholeArrayKey
      # decipherTextBin = @des.getBin(cipherText)
      decipherTextBin = hexToBin(cipherText)

      decipherTextBin = deciphering(decipherTextBin)
      hexStr = toHex(decipherTextBin)
      binding.pry


   end

def deciphering(decipherTextBin)
   fPResult = @des.initialPermutation(decipherTextBin)
   twoHalvesArr = @des.divideInTwo(fPResult)
   leftArr = twoHalvesArr[0]
   rightArr = twoHalvesArr[1]
   # Round
   i = 15
   while i > -1
      tempLeft = leftArr;
      desRoundResult = desRound(leftArr, i)
      leftArr = @des.xORRound(desRoundResult, rightArr)
      rightArr = tempLeft
      i-=1
   end
   swapArray = @des.lastSwap(leftArr, rightArr)
   joined = joinArrays(leftArr, rightArr)
   iPResult = @des.finalPermutation(joined)
   return iPResult
end

def hexToBin(plainText)

   matriz = Array.new()
   plainBinTextArr = [plainText].pack('H*')
   plainBinTextArr = plainBinTextArr.unpack('B64')

   plainBinText = Array.new()
   plainBinTextArr[0].each_char { |chr|
   plainBinText.push(chr) }


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

def desRound(leftArr, i)
   return @des.round(leftArr, i)

end
def joinArrays(leftArr, rightArr)
   swapArray = Array.new()
   blockSwapArray = Array.new()
   # TODO Preguntar acerca de orden!!
   rightArr.each { |e| swapArray.push(e) }
   leftArr.each { |e| swapArray.push(e) }
   #Modificado

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

def toHex(decipherTextBin)

   hexArray = Array.new()
   newArray = Array.new()
   binArray = Array.new()
   hexStr = ""
   binStr = ""
   i=0
   while i < 8
      newArray.push(@des.convertIntArrToStrArr(decipherTextBin[i]))
      i += 1
   end

   i = 0
   l = 0
   k = 0
   j = 3
   while l < 8
      while i < 2
         newArray[l][k..j].each { |e| binStr = binStr + e }
         hexStr = hexStr + binStr.to_i(2).to_s(16)
         j += 4
         k += 4
         i += 1
         if l == 7
         end
         binStr = ""
      end
      j = 3
      k = 0
      i = 0
      l += 1
   end
   return hexStr
end

end

a = DesDecipher.new()
