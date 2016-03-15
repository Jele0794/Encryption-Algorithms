require 'pry'
require_relative 's-box'
require_relative 'des'
class DesDecipher
   def initialize(cipherText = "HOLAMUND")
      @des = Des.new()
      decipherTextBin = @des.getBin(cipherText)


      decipherTextBin = deciphering(decipherTextBin)
      hexStr = toHex(decipherTextBin)


   end

def deciphering(decipherTextBin)
   fPResult = @des.initialPermutation(decipherTextBin)
   twoHalvesArr = @des.divideInTwo(fPResult)
   leftArr = twoHalvesArr[0]
   rightArr = twoHalvesArr[1]
   # Round
   i = 0
   while i < 16
      tempLeft = leftArr;
      desRoundResult = desRound(leftArr)
      leftArr = @des.xORRound(desRoundResult, rightArr)
      rightArr = tempLeft
      i+=1
   end
   swapArray = @des.lastSwap(leftArr, rightArr)
   joined = joinArrays(leftArr, rightArr)
   iPResult = @des.finalPermutation(joined)
   return iPResult
end
def desRound(leftArr)
   return @des.round(leftArr)

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
            binding.pry
         end
         binStr = ""
      end
      j = 3
      k = 0
      i = 0
      l += 1
   end
   binding.pry
   return hexStr
end

end

a = DesDecipher.new()
