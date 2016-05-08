#!/bin/bash
#Nombre del Script: ejercicio4.sh
#Trabajo Práctico nro 2
#Programación de scripts en tecnología bash
#Ejercicio 04

#Integrantes del grupo:
#Greve Iván - 38617763
#Boullon Daniel Ernesto - 36385582
#Silvero Heber Ezequiel - 36404597
#Valenzuela Juan Santiago - 38624490
#Nicolás Satragno - 38527273

validar_archivo_comprimido()
{
   if [ -d $1 ]; then
     echo se recibio como parametro un directorio
     exit
   fi
   if [ -f $1 ]; then
      ext=${1##*.}
      if [[ "$ext" != "zip" ]]; then
	echo no es un archivo .zip lo recibido como parametro
	exit
      fi 
   else
      echo el archivo recibido no existe
      exit
   fi

}

reporte_archivo_comprimido()
{  	
	validar_archivo_comprimido $1  #funcion para validar archivo .zip
	unzip -v $1 1> /tmp/salida.txt  2>/dev/null #redireciono la salida del unzip a archivo temporal. Caso de error, no se registrara en archivo temporal.
	estado=$?   #servira para informar en caso de que no se pueda acceder al .zip
	if [ "$estado" -gt 0 ]
	then
	echo error leyendo el archivo .zip. Revisar permisos
	exit
	fi
	cantLineasReporte=`awk 'END{print NR}' /tmp/salida.txt`  #cuento las lineas del archivo temporal
}


scriptErrorParametro(){
echo "Debe ingresar aunque sea dos parametos. Para mas informacion, utilice el help."
echo "Por ejemplo"
echo "bash ejercicio4.sh -h"
echo "bash ejercicio4.sh -help"
echo "bash ejercicio4.sh -?"
exit 0
}

ofrecerAyuda(){
echo "Para ejecutar correctamente, debe ingresar con el siguiente formato"
echo "bash script.sh [-l] o  [-d] o [-c]  o [-e] "
echo ""
echo "Ejemplos:"
echo "si desea listar el nombre y el tamaño original de cada archivo contenidos en un .zip "
echo 'bash ejercicio4.sh -l archivo.zip'
echo "si desea descomprimir un archivo .zip en un directorio destino"
echo 'bash ejercicio4.sh -d comprimido.zip directorio_destino' 
echo "si desea comprimir directorio en un archivo .zip"
echo 'bash ejercicio4.sh -c directorio nombre_archivo.zip' 
echo "si desea  listar por pantalla el nombre, tamaño comprimido, tamaño original y
ratio de compresión de cada uno de los archivos contenidos en un archivo.zip"
echo 'bash ejercicio4.sh -e comprimido.zip'

exit 0
}

#fin bloque funciones

#compruebo si invocan a la ayuda o sino valido la cantidad de parametros recibidos
  if [ "$1" = "-help" -o "$1" = "-?" -o "$1" = "-h" ];then
    ofrecerAyuda
  elif [ $# -ge 0 -a $# -gt 3 ];then   #si tengo 0 o mas de 3 parametros 
    scriptErrorParametro
  fi  


case "$1" in
-l)
	if [ "$#" -gt 2 ] 
	then
	  echo cantidad incorrecta de parametros
	  exit
	fi
	reporte_archivo_comprimido $2
	awk -v cantidadLineasArchivo=$cantLineasReporte -f parametro_l.awk "/tmp/salida.txt"	#invoco al script parametro_l.awk pasandole como parametro cantidadLineasArchivo para hacer reporte
        
;;
-d) 
#Descomprimo el archivo zip en destino
        if [ "$#" -lt 3 ] 
	then
	  echo se recibio menos de 3 parametros
	  exit
	fi
        #verifico que reciba un archivo .zip y posteriormente un  directorio
        if [ -f $2 ] && [ -d $3 ]
	then
	  ext=${2##*.}
          if [[ "$ext" != "zip" ]]; then
	   echo no es un archivo .zip lo recibido como parametro
	   exit
          fi
	  unzip -o $2 -d $3 2>/dev/null  #en caso de haberlo descomprimido antes, sobreescribo directorio sin preguntar en pantalla. Redirecciono error
          estado=$?
	  if [ "$estado" -ne 0 ]
	  then
	    echo error al descomprimir archivo. Revisar permisos
	    exit
     	  fi
	else
	  echo no se pudo descomprimir
	  exit
	fi  
;;
-c) 
      
	if [ "$#" -lt 3 ] 
	then
	  echo se recibio menos de 3 parametros
	  exit
	fi
	#si es un directorio valido el 2do parametro
	if [ -d $2 ]; then
         zip -r $3 $2 2>>/dev/null  #le paso como parametro primero el nombre_archivo y luego el directorio.
        estado=$?
	  if [ "$estado" -ne 0 ]
	  then
	    echo error al comprimir directorio. Revisar permisos
	    exit
	  fi
        else  
          echo directorio inexistente. No se puede comprimir.
          exit
       fi
	
;;
-e)
        if [ "$#" -gt 2 ] 
	then
	  echo cantidad incorrecta de parametros
	  exit
	fi
        reporte_archivo_comprimido $2
        awk -v cantidadLineasArchivo=$cantLineasReporte -f parametro_e.awk "/tmp/salida.txt" #invoco al script parametro_l.awk pasandole como parametro cantidadLineasArchivo para hacer reporte
;;
*)	
	scriptErrorParametro
	exit

;;
esac


