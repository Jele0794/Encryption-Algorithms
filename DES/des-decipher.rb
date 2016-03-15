require 'pry'
require_relative 's-box'
require_relative 'des'
class DesDecipher
   def initialize(cipherText = "CHEPO")
      @des = Des.new()
      decipherTextBin = @des.getBin(cipherText)


      decipherText = deciphering(decipherTextBin)


      binding.pry

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

end

a = DesDecipher.new()
