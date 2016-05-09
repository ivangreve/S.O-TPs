#!/bin/bash

# Nombre del Script: ej6_demonio.sh
# Trabajo Práctico nro 2
# Programación de scripts en tecnología bash
# Ejercicio 06

# Integrantes del grupo:
# Greve Iván - 38617763
# Boullon Daniel Ernesto - 36385582
# Silvero Heber Ezequiel - 36404597
# Valenzuela Juan Santiago - 38624490
# Nicolás Satragno - 38527273

# No ejecutes este script directamente! Usá ej6_cliente.sh :)

# Carga inicial de tamaños e impresión.

CARPETA=$1
RUTA_SALIDA=$2

TIEMPO_SLEEP=30

# Declaro el array asociativo donde se guardan extensión -> tamaño.
declare -A HASH_EXTENSIONES

# Y el array donde se guardan los hashes de los archivos.
declare -A HASH_MD5

# Este pedacito mágico nos permite separar en el for por \n y no espacios.
IFS=$'\n'

# Obtengo una lista con todos los archivos.
LISTA_ARCHIVOS=$( find "$CARPETA" -type f)

for ARCHIVO in $LISTA_ARCHIVOS
do
  # Por cada archivo, obtengo extensión y tamaño.
  NOMBRE_ARCHIVO=$(grep -o "/[^/]*$" <<< $ARCHIVO)
  NOMBRE_ARCHIVO=${NOMBRE_ARCHIVO:1}
  EXTENSION=$(cut -d'.' -f2- <<< $NOMBRE_ARCHIVO)
  SIZE=$(stat -c %s "$ARCHIVO" 2> /dev/null)

  if [ -z "${HASH_EXTENSIONES[$EXTENSION]+isset}" ]
  then
    # Si no está en el mapa, lo agregamos.
    HASH_EXTENSIONES[$EXTENSION]=$SIZE
  else
    # Si está, sumamos el tamaño a lo que ya había.
    (( HASH_EXTENSIONES[$EXTENSION] = ${HASH_EXTENSIONES[$EXTENSION]} + $SIZE ))
  fi

  HASH_MD5[$ARCHIVO]=$(md5sum $ARCHIVO | cut -d" " -f1)
done

SALIDA=""
for EXTENSION in ${!HASH_EXTENSIONES[@]}
do
  FECHA=`date "+%d/%m/%y %H:%M:%S"`
  SALIDA=$SALIDA$(printf "%s %-26s %-26s\\\\n" "$FECHA" "$EXTENSION" "${HASH_EXTENSIONES[$EXTENSION]}")
done
echo -en $SALIDA >> $RUTA_SALIDA


# Bucle en el que buscamos cambios.
while true
do
  sleep $TIEMPO_SLEEP

  HUBO_CAMBIOS=false

  # Buscamos cambios en el hash.
  unset NUEVO_HASH_MD5
  declare -A NUEVO_HASH_MD5

  # Obtengo una lista con todos los archivos.
  LISTA_ARCHIVOS=$( find "$CARPETA" -type f)

  for ARCHIVO in $LISTA_ARCHIVOS
  do
    NUEVO_HASH_MD5[$ARCHIVO]=$(md5sum $ARCHIVO | cut -d" " -f1)
  done

  if [[ ${#NUEVO_HASH_MD5[@]} != ${#HASH_MD5[@]} ]]
  then
    HUBO_CAMBIOS=true
  else
    for ARCHIVO in ${!NUEVO_HASH_MD5[@]}
    do
      if [[ ${NUEVO_HASH_MD5[$ARCHIVO]} != ${HASH_MD5[$ARCHIVO]} ]]
      then
        HUBO_CAMBIOS=true
        break
      fi
    done
  fi

  if [ $HUBO_CAMBIOS = true ]
  then
    unset NUEVO_HASH_EXTENSIONES
    declare -A NUEVO_HASH_EXTENSIONES

    # Copy paste del código de arriba porque no se pueden pasar arrays
    # asociativos por referencia en bash.
    # Al menos ya tenemos los archivos en el hash de md5 nuevo :)
    for ARCHIVO in ${!NUEVO_HASH_MD5[@]}
    do
      # Por cada archivo, obtengo extensión y tamaño.
      NOMBRE_ARCHIVO=$(grep -o "/[^/]*$" <<< $ARCHIVO)
      NOMBRE_ARCHIVO=${NOMBRE_ARCHIVO:1}
      EXTENSION=$(cut -d'.' -f2- <<< $NOMBRE_ARCHIVO)
      SIZE=$(stat -c %s "$ARCHIVO" 2> /dev/null)

      if [ -z "${NUEVO_HASH_EXTENSIONES[$EXTENSION]+isset}" ]
      then
        # Si no está en el mapa, lo agregamos.
        NUEVO_HASH_EXTENSIONES[$EXTENSION]=$SIZE
      else
        # Si está, sumamos el tamaño a lo que ya había.
        (( NUEVO_HASH_EXTENSIONES[$EXTENSION] = ${NUEVO_HASH_EXTENSIONES[$EXTENSION]} + $SIZE ))
      fi
    done

    SALIDA=""
    for EXTENSION in ${!NUEVO_HASH_EXTENSIONES[@]}
    do
      FECHA=`date "+%d/%m/%y %H:%M:%S"`
      if [[ ! ${HASH_EXTENSIONES[$EXTENSION]} = ${NUEVO_HASH_EXTENSIONES[$EXTENSION]} ]]
      then
        if [ -z ${HASH_EXTENSIONES[$EXTENSION]+isset} ]
        then
          DIFERENCIA="(nueva extensión)"
        else
          DIFERENCIA=$(bc <<< "scale=2; (${NUEVO_HASH_EXTENSIONES[$EXTENSION]} - ${HASH_EXTENSIONES[$EXTENSION]}) * 100 / ${HASH_EXTENSIONES[$EXTENSION]}")
          # Si no arranca con -, le agregamos un +.
          if [[ ! ${DIFERENCIA:0:1} = "-" ]]
          then
            DIFERENCIA=+$DIFERENCIA
          fi
          DIFERENCIA="($DIFERENCIA%)"
        fi
	SALIDA=$SALIDA$(printf "%s %-26s %-26s %-26s\\\\n" "$FECHA" "$EXTENSION" "${NUEVO_HASH_EXTENSIONES[$EXTENSION]}" "$DIFERENCIA")
      fi
    done

    for EXTENSION in ${!HASH_EXTENSIONES[@]}
    do
      if [ -z ${NUEVO_HASH_EXTENSIONES[$EXTENSION]+isset} ]
      then
        SALIDA=$SALIDA$(printf "%s %-26s %-26s %-26s\\\\n" $FECHA "$EXTENSION" "0" "(extensión removida)")
      fi
    done

    echo -en $SALIDA >> $RUTA_SALIDA

    # Limpio el hash de MD5s.
    unset HASH_MD5
    declare -A HASH_MD5
    for ARCHIVO in ${!NUEVO_HASH_MD5[@]}
    do
      HASH_MD5[$ARCHIVO]=${NUEVO_HASH_MD5[$ARCHIVO]}
    done

    # Limpio el hash de extensiones.
    unset HASH_EXTENSIONES
    declare -A HASH_EXTENSIONES
    for EXTENSION in ${!NUEVO_HASH_EXTENSIONES[@]}
    do
      HASH_EXTENSIONES[$EXTENSION]=${NUEVO_HASH_EXTENSIONES[$EXTENSION]}
    done
  fi
done
