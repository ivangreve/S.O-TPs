#!/bin/bash
#Nombre del Script: ejercicio2.sh
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
echo "para ejecutar correctamente, debe ingresar con el siguiente formato"
echo "./Ej2.sh [-u] o  [-a]
Script para el control de la conexión de los usuarios.
Parámetros permitidos:
-u usuario: muestra las conexiones activas de un usuario en particular, si no se
indica el usuario se toma al usuario que ejecuto el script.
-a: muestra los usuarios con conexiones activas y la última conexión de los usuarios
sin conexiones activas.
Si no se indican parámetros trabaja como si se hubiese indicado –a.
Ejemplo 
./Ej2.sh -u pepito
./Ej2.sh -a 
"
}
# Fin Funciones;


# Verificacion de paramtros:
parametro="mal";
if(( $# == 0 ))
then 
	parametro="-a";
else
	#veo si el parametro es para pedir ayuda:
	if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ]
		then
			ofrecerAyuda
			exit
		fi
	#Veo si el parametro es -u o -a
	if [ "$1" = '-u' -o "$1" = '-a' ]
		then
			parametro=$1;		
		fi
	#Si el parametro no es valido no se modifico(sigue "mal") termino el script.
	if [ "$parametro" = "mal" ]
		then
			echo "Parametro incorrecto, obtenga ayuda con -help, -h, o -?"
			exit;
		fi
	#veo si el usuario existe (pendiente)
	if [ $# -ge 2 ]
		then	
			if [ "$1" = "-u" -a $# == 2 ]
			then
				cat /etc/passwd | grep "$2" > /dev/null && exist=0 || exist=1
				if [ $exist -eq 0 ]
					then
						echo "El usuario existe: $2"
					else
						echo "El usuario "$2" no existe"
						exit;
					fi
			else
				echo "Parametros de sobra, obtenga ayuda con -help, -h, o -?"
				exit;
			fi
		fi
fi

# Fin verificacion de parametros;

if [ "$parametro" = "-a" ]
	then
		echo ""
		printf "%-30s %s\n" "Usuario" "UltimaConexion"
		divider==============================
                divider=$divider' '$divider
		echo $divider
		who | awk -F" " '{printf"%-30s Activo en %s\n",$1,$2}'  
		last -F | awk  -F " " -f reporte.awk  #llamo script awk para formatear salida

	fi
if [ "$parametro" = "-u"  ]
	then	
		if [ $# == 1 ]
		then 
			user=$(whoami)
		else
			user=$2
		fi

		echo $useruniq
		echo ""
		echo "Usuario Conexion"
		echo "======= =============="
		
		who | awk -F" "  '/'$user'/ {printf "%-10s    Activo en %s\n", $1,$2}'		
	fi

echo "fin"
