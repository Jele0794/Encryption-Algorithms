class Pldecipher

	def initialize(matrizAbcd, cipherText)
		@cipherText = cipherText
		@matrizAbcd = matrizAbcd
		@plainText = deciphering(@cipherText)
		puts "Texto desencriptado por el algoritmo: #{@plainText}"
	end

	def deciphering(cipherText)
		i = 0
		j = cipherText.length
		while i < j
			primerasLetras = cipherText[0,2]
			cipherText.slice!(0..1)
			# Si se encuentran las letras en alguna fila,
			# se realiza el cifrado de fila
			if searchRow(primerasLetras)
				plainText = "#{plainText}" + "#{rowDecipher(primerasLetras)}"

			# Si se encuentran las letras en alguna columna,
			# se realiza el cifrado de columna
			elsif searchCol(primerasLetras)
				plainText = "#{plainText}" + "#{colDecipher(primerasLetras)}"
			# Si no se encuentran las letras en fila o columna,
			# se realiza el cifrado en diagonal
			else
				plainText = "#{plainText}" + "#{diagDecipher(primerasLetras)}"
			end
			i += 2
		end
		return plainText
	end

	def rowDecipher (twoLetters)
		i = 0
		a = 0
		while twoLetters[0] != @matrizAbcd[a][i]
			i += 1
			# Si no encuentra la letra en la fila, cambia a la siguiente y reinicia puntero
			if i >= @matrizAbcd[a].length
				a +=1
				i = 0
			end
		end
		ubicacionLetraUno = i-1
		i = 0
		# Busca la segunda letra en la fila
		while twoLetters[1] != @matrizAbcd[a][i]
			i += 1
		end
		if twoLetters[1] == @matrizAbcd[a][i]
			ubicacionLetraDos = i-1
		end
		# Bloque de if's para corregir apuntador hacia el principio
		if ubicacionLetraUno < 0
			ubicacionLetraUno = @matrizAbcd[a].length-1
		elsif ubicacionLetraDos < 0
			ubicacionLetraDos = @matrizAbcd[a].length-1
		end
		# Bloque de if's para para asignar orden de letras de derecha a izquierda
		if ubicacionLetraUno > ubicacionLetraDos
			cipherText = "#{@matrizAbcd[a][ubicacionLetraUno]}" + "#{@matrizAbcd[a][ubicacionLetraDos]}"
		else
			cipherText = "#{@matrizAbcd[a][ubicacionLetraUno]}" + "#{@matrizAbcd[a][ubicacionLetraDos]}"
		end
		# Se regresan las dos letras encriptadas
		return cipherText
	end

	def colDecipher (twoLetters)
		i = 0
		a = 0
		while twoLetters[0] != @matrizAbcd[a][i]
			i += 1
			# Si no encuentra la letra en la fila, cambia a la siguiente y reinicia puntero
			if i >= @matrizAbcd[a].length
				a +=1
				i = 0
			end
		end
		ubicacionLetraUno = a-1
		a = 0
		# Busca la segunda letra en la columna
		while twoLetters[1] != @matrizAbcd[a][i]
			a += 1
		end
		if twoLetters[1] == @matrizAbcd[a][i]
			ubicacionLetraDos = a-1
		end

		# Bloque de if's para corregir apuntador hacia el principio de la columna
		if ubicacionLetraUno < 0
			ubicacionLetraUno = @matrizAbcd.length-1
		elsif ubicacionLetraDos < 0
			ubicacionLetraDos = @matrizAbcd.length-1
		end
		# Bloque de if's para para asignar orden de letras de abajo hacia arriba
		if ubicacionLetraUno > ubicacionLetraDos
			cipherText = "#{@matrizAbcd[ubicacionLetraUno][i]}" + "#{@matrizAbcd[ubicacionLetraDos][i]}"
		else
			cipherText = "#{@matrizAbcd[ubicacionLetraUno][i]}" + "#{@matrizAbcd[ubicacionLetraDos][i]}"
		end
		# Se regresan las dos letras encriptadas
		return cipherText
	end

	def diagDecipher (twoLetters)
		i = 0
		a = 0
		while twoLetters[0] != @matrizAbcd[a][i]
			i += 1
			# Si no encuentra la letra en la fila, cambia a la siguiente y reinicia puntero
			if i >= @matrizAbcd[a].length
				a +=1
				i = 0
			end
		end
		coordenadaXLetraUno = i
		coordenadaYLetraUno = a
		i = 0
		a = 0
		while twoLetters[1] != @matrizAbcd[a][i]
			i += 1
			# Si no encuentra la letra en la fila, cambia a la siguiente y reinicia puntero
			if i >= @matrizAbcd[a].length
				a +=1
				i = 0
			end
		end
		coordenadaXLetraDos = i
		coordenadaYLetraDos = a

		cipherText = "#{@matrizAbcd[coordenadaYLetraUno][coordenadaXLetraDos]}" + "#{@matrizAbcd[coordenadaYLetraDos][coordenadaXLetraUno]}"

		# Se regresan las dos letras encriptadas
		return cipherText

	end

	# Se buscan dos letras en fila
	def searchRow (twoLetters)
		i = 0
		a = 0
		while twoLetters[0] != @matrizAbcd[a][i]
			i += 1
			# Si no encuentra la letra en la fila, cambia a la siguiente y reinicia puntero
			if i >= @matrizAbcd[a].length
				a +=1
				i = 0
			end
		end
		i = 0
		# Busca la segunda letra en la fila
		while twoLetters[1] != @matrizAbcd[a][i]
			i += 1
			# Si no encuentra la segunda letra, regresa false
			if i >= @matrizAbcd[a].length
				return false
			end
		end
		if twoLetters[1] == @matrizAbcd[a][i]
			return true
		end
	end
	# Se buscan dos letras en columna
	def searchCol (twoLetters)
		i = 0
		a = 0
		while twoLetters[0] != @matrizAbcd[a][i]
			i += 1
			# Si no encuentra la letra en la fila, cambia a la siguiente y reinicia puntero
			if i >= @matrizAbcd[a].length
				a +=1
				i = 0
			end
		end
		a = 0
		# Busca la segunda letra en la columna
		while twoLetters[1] != @matrizAbcd[a][i]
			a += 1
			# Si no encuentra la segunda letra, regresa false
			if a >= @matrizAbcd.length
				return false
			end
		end
		if twoLetters[1] == @matrizAbcd[a][i]
			return true
		end
	end
end
