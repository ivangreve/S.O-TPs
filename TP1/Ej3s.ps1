<#
.SYNOPSIS
Muestra el porcentaje ocupado por cada tipo de archivo.

.DESCRIPTION
Muestra el porcentaje ocupado por cada tipo de archivo (determinado por la extensión) en un directorio especifico. Si no se ingresa el path se usara el path relativo.

.PARAMETER path
El directorio del archivo en el que se requiere para obtener los porcentajes de cada tipo de archivo.

.EXAMPLE



#>

<#
Nombre del Script: Ej3.ps1
Trabajo Practico nro 1
Programacion de scripts basicos en Powershell
Ejercicio 03

Integrantes del grupo:
Greve Iván - 38617763
Boullon Daniel Ernesto - 36385582
Silvero Heber Ezequiel - 36404597
Valenzuela Juan Santiago - 38624490
Nicolás Satragno - 38527273


Entrega: Primera Entrega


#>


Param(
  #Este  va a recibir la entrada por pipe si hubiera. Si no, queda en "blanco"
    [Parameter(Position=1, Mandatory = $false)][ValidateNotNullOrEmpty()][String] $path = “.”    
)