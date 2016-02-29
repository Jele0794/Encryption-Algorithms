require 'pry'
require_relative 'videcipher'

class Vigenere

	def initialize(keyword="mundo", plainText)
		@keyword = keyword
		@plainText = plainText
		@keyword.upcase!
		@plainText.upcase!
		@plainText.gsub!(/\s+/, "")
		@arregloAbcd = Array('A'..'Z')
		@arregloNums = Array(0..@arregloAbcd.length-1)
		@keywordProcesada = textManager
		arregloNumsKey = findKeyNumbers
		arregloNumsText = findTextNumbers
		@cipherText = ciphering(arregloNumsKey, arregloNumsText)

		puts "Texto plano: #{@plainText}"
		puts "Llave procesada: #{@keywordProcesada}"
		puts "Texto encriptado: #{@cipherText}"
		videcipher = Videcipher.new(@cipherText, arregloNumsKey)
	end

	def textManager
		if @plainText.length == @keyword.length
			keywordProcesada = "#{keywordProcesada}" + "#{@keyword}"
			return keywordProcesada
		elsif @plainText.length > @keyword.length
			i = 0
			numReptLlave = @plainText.length/@keyword.length
			while i < numReptLlave
				keywordProcesada = "#{keywordProcesada}" + "#{@keyword}"
				i += 1
			end
			numLetrasRestantes = @plainText.length - keywordProcesada.length
			keywordProcesada = "#{keywordProcesada}" + "#{@keyword[0, numLetrasRestantes]}"
			return keywordProcesada
		elsif @plainText.length < @keyword.length
			numLetrasSobrantes = @keyword.length - @plainText.length
			keywordProcesada = "#{keywordProcesada}" + "#{@keyword[0...-numLetrasSobrantes]}"
			return keywordProcesada
		end
	end

	def ciphering(arregloNumsKey, arregloNumsText)
		i = 0
		while i < arregloNumsKey.length
		residuo = mod(arregloNumsText[i], arregloNumsKey[i])
		cipherText = "#{cipherText}" + "#{@arregloAbcd[residuo]}"
		i += 1
		end
		return cipherText
	end

	def findKeyNumbers
		i = 0
		arregloNums = Array.new()
		@keywordProcesada.each_char {
			|letra|
			while letra != @arregloAbcd[i]
				i += 1
			end
			arregloNums.push(i)
			i=0
		}
		return arregloNums
	end

	def findTextNumbers
		i = 0
		arregloNums = Array.new()
		@plainText.each_char {
			|letra|
			while letra != @arregloAbcd[i]
				i += 1
			end
			arregloNums.push(i)
			i=0
		}
		return arregloNums
	end

	def mod(letraNum, keyNum)
		mod = (letraNum + keyNum) % 26
		return mod
	end
end

a = Vigenere.new("edmundo", "Meet me after the toga party")
