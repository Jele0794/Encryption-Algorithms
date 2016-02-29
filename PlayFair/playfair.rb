require 'pry'
require_relative "decipher"

class Playfair
	def initialize(keyword="mundo", plainText)
		@keyword = keyword
		@keyword.upcase!
		@matrizAbcd = crearMatriz
		@plainTextP = plainManager(plainText)
		puts "Texto plano porcesado: #{@plainTextP}"
		@cipherText = ciphering(@plainTextP)
		puts "Texto encriptado por el algoritmo: #{@cipherText}"
		decipher = Decipher.new(@matrizAbcd, @cipherText)
	end

	def crearMatriz
		matriz = Array.new()
		matrizAbc = Array.new()
		@keyword.each_char { |letra| matrizAbc.push(letra) }
		abecedario = "ABCDEFGHIKLMNOPQRSTUVWXYZ"
		abecedario.each_char { |letra| matrizAbc.push(letra) }
		# La siguiente línea elimina duplicados del arreglo
		matrizAbc.uniq!
		# Se crean dos contadores
		i = 0
		j = 0
		# Con este while se planea llenar la matriz "matriz"
		while i < 5
			# Se inserta en la posición i el segmento de 5 elementos
			# desde la posición j de la matriz "matrizAbc".
			matriz.insert(i, matrizAbc[j, 5])
			i += 1
			j = j+5
		end
		return matriz
	end

	# Este método se encarga de administrar el texto plano
	def plainManager (plainText)
		# Se convierte el texto plano a mayúscula además
		# de eliminar espacios
		plainText.upcase!
		plainText.gsub!(/\s+/, "")

		# Se ejecuta el código mientras no deje de haber letras
		# en la variable 'plainText'
		while !plainText.empty?
			# Se guardan las primeras letras y se eliminan de
			# la variable 'plainText'
			primerasLetras = plainText[0,2]
			plainText.slice!(0..1)
			# Este while sirve para agregar 'X' si se repiten letras
			while primerasLetras[0] == primerasLetras[1]
				plainText.prepend(primerasLetras)
				plainText.insert(1, "X")
				primerasLetras = plainText[0,2]
				plainText.slice!(0..1)
			end
			plainTextProcesado = "#{plainTextProcesado}" + "#{primerasLetras}"
		end
		# Si el resultado no tiene una longitud par, se añade una X al final
		if (plainTextProcesado.length % 2) != 0
				plainTextProcesado = "#{plainTextProcesado}" + "X"
		end
		return plainTextProcesado
	end

	# Proceso general de cifrado
	def ciphering (plainTextProcesado)
		i = 0
		j = plainTextProcesado.length
		while i < j

			primerasLetras = plainTextProcesado[0,2]
			plainTextProcesado.slice!(0..1)
			# Si se encuentran las letras en alguna fila,
			# se realiza el cifrado de fila
			if searchRow(primerasLetras)
				cipherText = "#{cipherText}" + "#{rowCipher(primerasLetras)}"

			# Si se encuentran las letras en alguna columna,
			# se realiza el cifrado de columna
			elsif searchCol(primerasLetras)
				cipherText = "#{cipherText}" + "#{colCipher(primerasLetras)}"
			# Si no se encuentran las letras en fila o columna,
			# se realiza el cifrado en diagonal
			else
				cipherText = "#{cipherText}" + "#{diagCipher(primerasLetras)}"
			end
			i += 2
		end

		return cipherText
	end

	def rowCipher (twoLetters)
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
		ubicacionLetraUno = i+1
		i = 0
		# Busca la segunda letra en la fila
		while twoLetters[1] != @matrizAbcd[a][i]
			i += 1
		end
		if twoLetters[1] == @matrizAbcd[a][i]
			ubicacionLetraDos = i+1
		end
		# Bloque de if's para corregir apuntador hacia el principio
		if ubicacionLetraUno >= @matrizAbcd[a].length
			ubicacionLetraUno = 0
		elsif ubicacionLetraDos >= @matrizAbcd[a].length
			ubicacionLetraDos = 0
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

	def colCipher (twoLetters)
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
		ubicacionLetraUno = a+1
		a = 0
		# Busca la segunda letra en la columna
		while twoLetters[1] != @matrizAbcd[a][i]
			a += 1
		end
		if twoLetters[1] == @matrizAbcd[a][i]
			ubicacionLetraDos = a+1
		end

		# Bloque de if's para corregir apuntador hacia el principio de la columna
		if ubicacionLetraUno >= @matrizAbcd.length
			ubicacionLetraUno = 0
		elsif ubicacionLetraDos >= @matrizAbcd.length
			ubicacionLetraDos = 0
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

	def diagCipher (twoLetters)
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

a = Playfair.new("isabel", "Hola papa soy mundo")
