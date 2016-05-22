#!/bin/bash

# Nombre del Script: ej6_cliente.sh
# Trabajo Práctico nro 2
# Programación de scripts en tecnología bash
# Ejercicio 06

# Integrantes del grupo:
# Greve Iván - 38617763
# Boullon Daniel Ernesto - 36385582
# Silvero Heber Ezequiel - 36404597
# Valenzuela Juan Santiago - 38624490
# Nicolás Satragno - 38527273

# Constantes
EXIT_SUCCESS=0
EXIT_ERROR=1

TRUE=1
FALSE=0

# La ruta en la que están los archivos con los PIDs y carpetas de los trabajos.
RUTA_ARCHIVOS=/var/tmp/demoniodelmejorgrupo

# La ruta a los buffers (los archivos de salida) de los trabajos.
RUTA_BUFFERS=/var/tmp/demoniodelmejorgrupo_buffers

error_y_salir() {
  echo $1
  ayuda
  exit $EXIT_ERROR
}

ayuda() {
  echo "ejercicio6: administra trabajos que controlan el tamaño de archivos.     "
  echo "                                                                         "
  echo "USO                                                                      "
  echo "  ejercicio6 start RUTA                                                  "
  echo "  ejercicio6 status                                                      "
  echo "  ejercicio6 stop ID_TRABAJO                                             "
  echo "  ejercicio6 listen ID_TRABAJO                                           "
  echo "                                                                         "
  echo "COMANDOS                                                                 "
  echo "  start      arranca un trabajo en la RUTA dada.                         "
  echo "  status     muestra información de los trabajos activos.                "
  echo "  stop       detiene al trabajo con ID_TRABAJO (consultar con status)    "
  echo "  listen     imprime en pantalla cambios en los archivos del trabajo     "
  echo "             ID_TRABAJO.                                                 "
}

# Verifica la existencia del trabajo dado y sale con un mensaje de error si no
# existe.
verificar_existencia_trabajo() {
  stat "$RUTA_ARCHIVOS/$1" &> /dev/null
  if [[ $? != 0 ]]
  then  # El archivo no existe, por lo tanto el trabajo tampoco.
    echo "El trabajo $1 no existe"
    exit $EXIT_FAILURE
  fi
}

# Arranca el demonio. Recibe como parámetro la carpeta que debe inspeccionar.
arrancar() {
  if [[ ! -d $1 ]]
  then
    error_y_salir "La carpeta dada no existe"
  fi

  # Absolutizamos la ruta.
  CARPETA_NUEVO_DEMONIO=$(realpath $1)

  # Creamos la carpeta si es que no existe.
  mkdir $RUTA_ARCHIVOS &> /dev/null

  # Verifico que la carpeta no esté ya siendo cubierta por otro demonio activo.
  for ARCHIVO in `ls $RUTA_ARCHIVOS`
  do
    LINEA=`cat $RUTA_ARCHIVOS/$ARCHIVO`
    CARPETA=`grep -o :.* <<< $LINEA`

    # Ignoro el :
    CARPETA=${CARPETA:1}

    if [[ $CARPETA = $CARPETA_NUEVO_DEMONIO ]]
    then
      echo "La carpeta $CARPETA ya está siendo cubierta por la tarea $ARCHIVO"
      exit $EXIT_FAILURE
    fi

    if [[ $CARPETA =~ ^$CARPETA_NUEVO_DEMONIO ]]
    then
      echo "La carpeta $CARPETA, incluída en $CARPETA_NUEVO_DEMONIO, ya está siendo cubierta por la tarea $ARCHIVO"
      exit $EXIT_FAILURE
    fi

    if [[ $CARPETA_NUEVO_DEMONIO =~ ^$CARPETA ]]
    then
      echo "La carpeta $CARPETA_NUEVO_DEMONIO ya está siendo cubierta por la tarea $ARCHIVO"
      exit $EXIT_FAILURE
    fi
  done

  # Podemos crear el demonio.
  # Nos fijamos cuál es el ID del demonio más pequeño disponible.
  ID_NUEVO_DEMONIO=1
  stat "$RUTA_ARCHIVOS/$ID_NUEVO_DEMONIO" &> /dev/null
  while [[ $? = 0 ]]
  do
    (( ID_NUEVO_DEMONIO=ID_NUEVO_DEMONIO + 1 ))
    stat "$RUTA_ARCHIVOS/$ID_NUEVO_DEMONIO" &> /dev/null
  done

  # Arrancamos el demonio.
  mkdir $RUTA_BUFFERS &> /dev/null
  echo "" > $RUTA_BUFFERS/$ID_NUEVO_DEMONIO
  bash ./ej6_demonio.sh "$CARPETA_NUEVO_DEMONIO" "$RUTA_BUFFERS/$ID_NUEVO_DEMONIO" "$RUTA_ARCHIVOS/$ID_NUEVO_DEMONIO" &

  PID_DEMONIO=$!

  echo "Arrancado trabajo en carpeta $CARPETA_NUEVO_DEMONIO con ID $ID_NUEVO_DEMONIO"
  echo "Para finalizarlo manualmente (no recomendado), usar SIGTERM en $PID_DEMONIO"

  # Guardamos los datos del demonio en su archivo temporal.
  echo $PID_DEMONIO:$CARPETA_NUEVO_DEMONIO > $RUTA_ARCHIVOS/$ID_NUEVO_DEMONIO
}

# Consulta el estado de los demonios.
consultar_status() {
  # ls se queja si la carpeta no existe. Oculto el error creándola primero :).
  mkdir $RUTA_ARCHIVOS &> /dev/null

  if [[ `ls $RUTA_ARCHIVOS` = "" ]]
  then
    echo "No hay trabajos en ejecución"
    exit $EXIT_SUCCESS
  fi

  for ARCHIVO in `ls $RUTA_ARCHIVOS`
  do
    LINEA=`cat $RUTA_ARCHIVOS/$ARCHIVO`
    PID=`grep -o ^[0-9]* <<< $LINEA`
    CARPETA=`grep -o :.* <<< $LINEA`

    # Ignoro el :
    CARPETA=${CARPETA:1}
    echo "Trabajo $ARCHIVO: carpeta $CARPETA"
  done
}

# Detiene un demonio, recibiendo su ID como parámetro.
detener() {
  verificar_existencia_trabajo $1

  LINEA=`cat $RUTA_ARCHIVOS/$1`
  PID=`grep -o ^[0-9]* <<< $LINEA`

  kill $PID

  echo "Trabajo $1 detenido"
}

# Escucha al trabajo dado.
listen() {
  echo "Escuchando al trabajo $1. Ctrl + C para salir (el trabajo seguirá corriendo)."

  verificar_existencia_trabajo $1

  tail -n +0 -f $RUTA_BUFFERS/$1
}

# Validación de parámetros y delegación a funciones.
case $1 in
  start)
     if [[ $2 = "" ]]
     then
       error_y_salir "Falta la ruta"
     fi
     arrancar $2
     ;;
  status)
    consultar_status
    ;;
  stop)
     if [[ $2 = "" ]]
     then
       error_y_salir "Falta el ID de trabajo. Consultar con status."
     fi
     detener $2
     ;;
  listen)
     if [[ $2 = "" ]]
     then
       error_y_salir "Falta el ID de trabajo. Consultar con status."
     fi
    listen $2
    ;;
  *)
    if [[ $1 == "-?" ]]
    then
      ayuda
      exit $EXIT_SUCCESS
    fi
    if [[ $1 == "" ]]
    then
      echo "Falta el comando"
    else
      echo "Comando $1 desconocido"
    fi
    ayuda
    exit $EXIT_ERROR
esac

