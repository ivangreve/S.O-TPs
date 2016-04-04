<#
.SYNOPSIS
Resuelve un sistema de ecuaciones de n variables y n incógnitas.
.DESCRIPTION
Recive un txt ( por defecto en la raiz del script con el nombre gauss.txt)
.PARAMETER path
El directorio del archivo en el que se requiere para sacar los coeficioneste de los datos

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
    [Parameter(Position=1, Mandatory = $false)][ValidateNotNullOrEmpty()][String] $path = "gauss.txt”    
)

$array = [System.Collections.ArrayList]@()

$contenido = Get-Content $path

$i = 0


foreach($obj in $contenido)
{
    if($i -eq 0)
    {
        $N = $obj
    }
    else
    {
        $linea = $obj -split ""
        $array.Add($linea)
        #Write-Host $linea
    $i++
    }

}

Write-Host " "
write-host $array[0][1] 
#La matriz se llena pero desde la segunda fila nose porque(? si quieren jueguen con las posiciones y van a ver (Creo que guarda el salto de linea),
#Cuando ejecuta nose porque motivo me muestra "0 1 2" , creo que es problema del metodo Add()

Write-Host " "
write-host "N:"$N
