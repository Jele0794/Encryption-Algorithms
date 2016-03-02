### Subject: Information Security
### Lecturer: Dr. Vicente Alarcón Aquino
### Student: Jorge Edmundo López Enríquez -146165
### Student: José Ramón Ruiz Castro - 147014
### Date: March 1, 2016

## Abstract
For this homework we implement two cipher techniques, for this, we used the programming language Ruby, a dynamic, reflective, object-oriented, general-purpose programming language that supports multiple programming paradigms, including functional, object-oriented, and imperative. We used the language in an object-oriented approach.

## Introduction
The implemented cipher techniques are Playfair cipher and Vigenere cipher. The Playfair cipher technique, encrypts pairs of letters (digraphs), instead of single letters as in the simple substitution cipher. The Playfair cipher uses a 5×5 square. This method permits the encryption of 25 letters, because the alphabet contains 26 letters, two letters are combined in the same cell of the square, usually I and J. To generate the matrix, we select a keyword, beginning with the first row, enter the keyword from left to right skipping letters previously used and continuing on to the second (third, fourth or fifth) row if necessary. After entering the keyword, the remaining letters of the alphabet are entered in order. The plaintext is divided into digraphs. If necessary an x is added at the end of the message to make the number of letters come out even. If there is a digraph that consists of a double letter, an x is inserted between double letters before encrypting. The rules for encrypting are:

1. If both letters of the diagram lie in the same row, then each letter is encrypted by the letter immediately to its right.
2. If both letters of the diagram are in the same column, then each letter is encrypted by the letter immediately below it.
3. In the remaining case, each letter is exchanged by the letter at the intersection of its row and the other letter's column.

The Vigenère cipher uses a 26×26 table with A to Z as the row heading and column heading. The first row of this table has the 26 English letters. Starting with the second row, each row has the letters shifted to the left one position in a cyclic way. the Vigenère cipher also requires a keyword, which is repeated so that the total length is equal to that of the plaintext. To encrypt, pick a letter in the plaintext and its corresponding letter in the keyword, use the keyword letter and the plaintext letter as the row index and column index, respectively, and the entry at the row-column intersection is the letter in the ciphertext. Vigenère cipher can also be described using modular arithmetic by first transforming the letters of the alphabet into numbers. Vigenère encryption, E, using the key K can then be represented as:

 **Ci = EK(Mi) = (Mi + Ki) mod 26**

## Description
Implementing Playfair
For this implementation, first we created a matrix given a keyword, for this we add to an array, letter by letter the keyword, then fill the array with the every letter of the alphabet in order, following that we use a method that checks every letter on the matrix and eliminate any duplicate, finally we insert to the matrix the letters in the array, making a 5x5 array. The I and J in the matrix are considered the same, so we consider I as J, and eliminate the J.

```ruby
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
```

Then we manipulate the plaintext to fix for the ciphering method, first the plaintext is converted to uppercase letters, then it eliminates spaces and punctuation marks. Then the plaintext is checked two letters at a time, verifying there are not repeated letters in the digrams, if there are repeated letters it adds an X between them and proceed with the method. Finally if the number of letters in the plaintext is not even, it adds an X to the end.
```ruby
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
```

With this, we can proceed to encrypt the message, given the processed plaintext, it applies the rules of the encrypting algorithm.
```ruby
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
```

### Implementing Vigenère
For this implementation, first, given the keyword and the plaintext, we repeated the keyword so that its total length is equal to that of the plaintext, this method, checks the length of the keyword with the length of the plaintext, if the keyword is smaller than the plaintext, it repeats until is equal or bigger than the plaintext, then it removes the extra letters. And If it is bigger than the plaintext, the keyword is reduced to the length of the plaintext.
```ruby
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
```

With this, we can cipher the plaintext, we use the mod formula to perform the ciphering.
```ruby
def ciphering(arregloNumsKey, arregloNumsText)
	i = 0
	while i < arregloNumsKey.length
	residuo = mod(arregloNumsText[i], arregloNumsKey[i])
	cipherText = "#{cipherText}" + "#{@arregloAbcd[residuo]}"
	i += 1
	end
	return cipherText
end
```

## Results
### Playfair
```console
$ ruby playfair.rb
Llave: monarchy
Plain text: meet me after the toga party
Texto plano porcesado: MEETMEAFTERTHETOGAPARTYX
Texto encriptado por el algoritmo: CLKLCLOILKDZCFPRINSODZBW
Texto desencriptado por el algoritmo: MEETMEAFTERTHETOGAPARTYX
```

```console
@matrizAbcd
=> [["M", "O", "N", "A", "R"],
   ["C", "H", "Y", "B", "D"],
   ["E", "F", "G", "I", "K"],
   ["L", "P", "Q", "S", "T"],
   ["U", "V", "W", "X", "Z"]]
```

### Vigenère
```console
$ ruby vigenere.rb
Texto plano: WEAREDISCOVEREDSAVEYOURSELF
Llave procesada: DECEPTIVEDECEPTIVEDECEPTIVE
Texto encriptado: ZICVTWQNGRZGVTWAVZHCQYGLMGJ
Texto desencriptado: WEAREDISCOVEREDSAVEYOURSELF

```

## Conclusions
The implementation of this cipher techniques it's a great exercise to comprehend the complexity of the encryption algorithms, despite the simplicity of this algorithms.
Although it is easy to create a cipher with a complicated combination of transposition and substitution of letters, this kind of algorithms can be attacked and deciphered easily with a good computer.

For the source code, visit: https://github.com/Jele0794/Encryption-Algorithms

## References
* Retrieved February 29, 2016, from MapleSoft: http://www.maplesoft.com/support/help/Maple/view.aspx?path=MathApps%2FVigenereCipher

* Christensen, C. (2006). Poligraphic Ciphers. Retrieved February 29, 2016, from Northern Kentucky University: http://www.nku.edu/~christensen/section%2019%20playfair%20cipher.pdf
* Matsumoto, Y. (n.d.). Retrieved February 29, 2019, from Ruby: https://www.ruby-lang.org/en/
