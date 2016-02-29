class Videcipher

	def initialize(cipherText, arregloNumsKey)
		@cipherText = cipherText
		@arregloNumsKey = arregloNumsKey
		@arregloAbcd = Array('A'..'Z')
		arregloNumsCipText = findCipTextNumbers
		@plainText = deciphering(@arregloNumsKey, arregloNumsCipText)
		puts "Texto desencriptado: #{@plainText}"

	end

	def deciphering(arregloNumsKey, arregloNumsCipText)
		i = 0
		while i < arregloNumsKey.length
		residuo = modDes(arregloNumsCipText[i], arregloNumsKey[i])
		plainText = "#{plainText}" + "#{@arregloAbcd[residuo]}"

		i += 1
		end
		return plainText
	end

	def findCipTextNumbers
		i = 0
		arregloNums = Array.new()
		@cipherText.each_char {
			|letra|
			while letra != @arregloAbcd[i]
				i += 1
			end
			arregloNums.push(i)
			i=0
		}
		return arregloNums
	end

	def modDes(letraCipNum, keyNum)
		mod = (letraCipNum - keyNum) % 26
		return mod

	end

end
