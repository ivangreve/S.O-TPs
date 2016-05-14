#!/bin/bash
#Nombre del Script: ejercicio3.sh
#Trabajo Práctico nro 2
#Programación de scripts en tecnología bash
#Ejercicio 04

#Integrantes del grupo:
#Greve Iván - 38617763
#Boullon Daniel Ernesto - 36385582
#Silvero Heber Ezequiel - 36404597
#Valenzuela Juan Santiago - 38624490
#Nicolás Satragno - 38527273

# Funciones:
ofrecerAyuda(){
echo "Para ejecutar correctamente, debe ingresar con el siguiente formato"
echo "./Ej3.sh [ruta/archivo] 
El script informa los ejecutables en el directorio PATH
La ruta del archivo de salida y el archivo de salida son parametros.
(parámetro 1 del script), con el siguiente formato: ruta/archivo. 
De no especificarse parámetro, el script mostrará el reporte por pantalla
El archivo y directorio debe tener permisos de escritura.
De no existir el archivo, se creara en la ruta parametrizada.
Ejemplo:
./Ej3.sh reporte
./Ej3.sh Escritorio/reporte"
return
}
# Fin Funciones;


# Verificacion de paramtros:
if(( $# == 0 ))
then 
	path_check="no";
else
	#veo si el parametro es para pedir ayuda:
	if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]
		then
			ofrecerAyuda
			exit
		fi

	
	if [ $# -ge 2 ]
		then	
			echo "Parametros de sobra, obtenga ayuda con -?"
			exit;
		fi

	#Veo si el path de salida es valido.
		if [ -d "$1" ]
		then
			echo "Error formato parametro, no se especifico el nombre del archivo, debe tener el siguiente formato: ruta/archivo"
			echo "Obtenga ayuda con -?"
			exit;
		fi

		if [ -f "$1" ]
		then
			if [ -w "$1" ]
			then
				path_check="si"
				pathSalida=$1	
			else
				echo "No hay permisos de escritura en el archivo $1"
				exit;			
			fi
		else	
			if [ -d "$(dirname "$1")" ]
			then

				if [ -w "$(dirname "$1")" ]
				then	
					> "$1"
					path_check="si"
					pathSalida=$1
					echo "El archivo no existe se creo en $(dirname "$1")/."
				else
					echo "No hay permisos de escritura en la carpeta $(dirname "$1")/"
					echo "Obtenga ayuda con -?"					
					exit;			
				fi

			else
				echo "Ruta incorrecta."
				echo "Obtenga ayuda con -?"
				exit;
			fi
		fi
	#Mas de un parametro
	
fi
ejecutablesPATH=0;
vector="";
i=0;
IFS=:
for path in $PATH 
	do
		if [ -d "$path" ] 
		then 	
			vector[$i]=$(find "$path" -type f -executable | wc -l)
			(( ejecutablesPATH+=vector[$i] ))
		else
			echo "No existe la ruta $path."
			vector[$i]=0
			
		fi 
		(( i++ ))
	done

#codigo:
i=0;


if [ "$path_check" = "no" ]
	then 
		echo "Usuario: $(whoami)" 
		echo "Cantidad de comandos disponibles desde el PATH: $ejecutablesPATH."
		echo "Detalle de comando disponibles por directorio:"
		for path in $PATH 
			do 
				if [ ${vector[$i]} -ne 0 ]
				then
					echo "     $path: ${vector[$i]}"	
				fi
				(( i++ ))
			done 
	else
		echo "Usuario: $(whoami)" > "$pathSalida"
		echo "Cantidad de comandos disponibles desde el PATH: $ejecutablesPATH." >> "$pathSalida"
		echo "Detalle de comando disponibles por directorio:" >> "$pathSalida"
		for path in $PATH 
			do
				if [ ${vector[$i]} -ne 0 ]
				then
					echo "     $path: ${vector[$i]}" >> "$pathSalida"
				fi
				(( i++ ))
			done 
	fi
