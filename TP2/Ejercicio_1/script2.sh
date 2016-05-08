#!/bin/bash

#Nombre del Script: ej07.sh
#Trabajo Práctico nro 2
#Programación de scripts en tecnología bash
#Ejercicio 01

# Integrantes del grupo:
# Greve Iván - 38617763
# Boullon Daniel Ernesto - 36385582
# Silvero Heber Ezequiel - 36404597
# Valenzuela Juan Santiago - 38624490
# Nicolás Satragno - 38527273

./script1.sh 10
echo "Resultado $variable"
. script1.sh 15
echo "Resultado $variable"
./script1.sh $$		#Con $$ muestro el Pid del script en ejecución
echo 'Resultado $variable' #Al utilizar comillas fuertes se va a mostrar textual lo que este dentro de ellas


#a. ¿Qué realiza el script1?
	#Al script1 le llega por el primer parametro ($1) un valor enviado cuando el script2 lo ejecuta, 
	#y script1 se lo asigna a $variable y lo muestra.


#b. Mencione como se pasan/emplean los parámetros en scripts de bash.
	
	#Los parametros los paso en la ejecución de nuestro script Ej: $ ./mi_script.sh "Sistemas" "Operativos"
	#Y los recibo con las variables ${Número poscicional del parametros}, Por ejemplo:


	#$ ./mi_script.sh "Sistemas" "Operativos" (Ejecuto)

	#echo "El 1er parámetro es: $1"
	#echo "El 2do parámetro es: $2"

	#Salida:
	#El 1er parámetro es: Sistemas
	#El 2do parámetro es: Operativos


#c. ¿Qué particularidad detecta dentro de script2 con la variable?

	#Cuando ejecuto ". script1.sh 15", el proceso (script1.sh) se
	#ejecuta desde el mismo intérprete, es decir, por ende a diferencia de las primeras 2 ejecuciones en la tercera
	#se comparten las mismas variables entre los 2 scripts.

#d. Menciones las diferentes formas de ejecutar un script

	#Podemos ejecutar un script de las siguientes formas:
		# $ ./nombre-del-script.sh  (Desde una dirección relativa)
		# $	/home/user/.../nombre-del-script.sh (Desde una dirección absoluta)
		# $	bash nombre-del-script.sh (Indicandole el interprete)

#e. ¿Qué información brinda la variable “$$”? ¿Qué otras variables similares conoce? Explíquelas.

# La variable $$: brinda el PID del Shell que esta interpretando el script. Otras variables similares son:
		# - $0: brinda el nombre del script ejecutado.
		# - $@: brinda la lista de los parámetros ingresados en el script
		# - $*: brinda la llamada completa del script
		# - $?: brinda el valor retorno del último comando
		# - $# brinda la cantidad de parámetros ingresados junto al script.


#f. Explique las diferencias entre los distintos tipos de comillas que se pueden utilizar en Shell scripts. 
#Realice un ejemplo para tipo de comilla.

# Se pueden usar tres tipos de comillas en Shell scripts:
		# - " ": comilla débil, es decir que cuando reconoce una variable, un parámetro o un comando entre otras cosas
		#	 lo toma como tal y no como un String.
				#Ej: variable=10; echo "$variable" , Muestra el valor de la variable (10)

		# - ' ': comilla fuerte, es decir que todo lo encerrado por estas comillas es un String. 
				#Ej: variable=10; echo '$variable' , Muestra textual lo que hay entre comillas ($variable)

		# - ` `: comillas de ejecución, se utiliza para encerrar comandos entre ellas y asignarlos a una variable. 
				#Ej: Dir=`ls -l`
