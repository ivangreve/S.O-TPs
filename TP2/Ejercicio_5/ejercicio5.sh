#!/bin/bash

# Nombre del Script: ejercicio5.sh
# Trabajo Práctico nro 2
# Programación de scripts en tecnología bash
# Ejercicio 05

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

fecha() {
  echo $(date +%d-%m-%y) a las $(date +%H:%M)
}

mensaje() {
  if [[ $VERBOSE = $TRUE ]]
  then
    echo $1
  fi
}

error_y_salir() {
  echo $1
  ayuda
  exit $EXIT_ERROR
}

registrar_en_log_y_terminar() {
  if [[ $LOGCONFIGURACION == "" ]]
  then
    mensaje "No se guarda log de configuración"
    exit $EXIT_SUCCESS
  fi

  if [[ -e $LOGCONFIGURACION && -w $LOGCONFIGURACION ]]
  then
    mensaje "Registrando en log de configuración"
    echo $1 >> "$LOGCONFIGURACION"
  else
    mensaje "Cuidado: no se puede escribir el archivo de log $LOGCONFIGURACION"
  fi

  exit $EXIT_SUCCESS
}

ayuda() {
  echo "ejercicio5: actualiza la configuración de un archivo.                    "
  echo "                                                                         "
  echo "USO                                                                      "
  echo "  ejercicio5 [-?]                                                        "
  echo "  ejercicio5 [-v] NOMBRE_ARCHIVO CLAVE VALOR                             "
  echo "                                                                         "
  echo "OPCIONES                                                                 "
  echo "  -?                habilita el modo n00b (imprime la ayuda)             "
  echo "  -v                habilita el modo suegra (verbose)                    "
  echo "  NOMBRE_ARCHIVO    ruta al archivo de configuración                     "
  echo "  CLAVE             regexp coincidente con clave que modificar           "
  echo "  VALOR             nuevo valor                                          "
  echo "                                                                         "
  echo "COMPORTAMIENTO                                                           "
  echo "  Si la clave no se encuentra en el archivo, se agrega al final de este. "
  echo "  De lo contrario, se actualiza el valor existente. Para configurar una  "
  echo "  clave vacía, usar \"\" como parámetro.                                 "
  echo "                                                                         "
  echo "  Si la clave se encuentra múltiples veces solo se modificará la primera."
  echo "                                                                         "
  echo "REGISTRO                                                                 "
  echo "  Se guardará un registro de las actualizaciones e inserciones si la     "
  echo "  variable de entorno LOGCONFIGURACION apunta a un archivo que se pueda  "
  echo "  escribir                                                               "
}

# Modo "ayuda".
if [[ $1 = "-?" ]]
then
  ayuda
  exit $EXIT_SUCCESS
fi

# Incialización de parámetros.
if [[ $1 = "-v" ]]
then
  echo "Modo suegra"
  shift
  VERBOSE=$TRUE
else
  VERBOSE=$FALSE
fi

ARCHIVO=$1
CLAVE=$2
VALOR=$3

# Validación de parámetros.

if [[ $# != 3 ]]
then
  error_y_salir "La cantidad de parámetros no es válida"
fi

if [[ ! -e $ARCHIVO ]]
then
  error_y_salir "$ARCHIVO no existe"
fi

if [[ ! -f $ARCHIVO ]]
then
  error_y_salir "$ARCHIVO no es un archivo regular"
fi

if [[ ! -w $ARCHIVO ]]
then
  error_y_salir "$ARCHIVO no se puede escribir"
fi

# Buscamos la clave en el archivo.
TEXTO_LINEA_ORIGINAL=$(grep -m 1 -n ^${CLAVE}= < "$ARCHIVO")

if [[ $TEXTO_LINEA_ORIGINAL != "" ]]
then
  # La clave fue encontrada. Obtenemos de grep el número de línea.
  LINEA=$(grep ^[0-9]* -o <<< $TEXTO_LINEA_ORIGINAL)

  # Y el valor original de la clave.
  VALOR_ORIGINAL=$(grep =.*$ -o <<< $TEXTO_LINEA_ORIGINAL)
  # Quitamos el primer caracter (el =).
  VALOR_ORIGINAL=${VALOR_ORIGINAL:1}

  if [[ $VALOR = $VALOR_ORIGINAL ]]
  then
    mensaje "La clave ya tenia esa configuración en el archivo"
    exit $EXIT_SUCCESS
  fi

  mensaje "Encontrada clave de configuración en línea $LINEA"
  mensaje "Valor original: $VALOR_ORIGINAL"
  mensaje "Actualizando $CLAVE a $VALOR"

  # Texto completo por el que vamos a remplazar la clave vieja.
  TEXTO=$"# Modificado el $(fecha) por $(whoami).\
 Valor previo: $VALOR_ORIGINAL\\n$CLAVE=$VALOR"

  # Remplazamos (c) línea $LINEA por $TEXTO en $ARCHIVO.
  sed -i ${LINEA}c"$TEXTO" "$ARCHIVO"

  registrar_en_log_y_terminar "[$(fecha) - $(whoami)] modificada la clave \
                              $CLAVE de $ARCHIVO ($VALOR_ORIGINAL > $VALOR)"
else
  # La clave no está, la adjuntamos.
  mensaje "Agregando clave $CLAVE"

  # Texto completo que se agrega al final del archivo.
  TEXTO=$"# Agregado el $(fecha) por $(whoami).\
\n$CLAVE=$VALOR"

  echo -e $TEXTO >> "$ARCHIVO"

  registrar_en_log_y_terminar "[$(fecha) - $(whoami)] agregada la clave \
                              $CLAVE de $ARCHIVO (valor $VALOR)"
fi
