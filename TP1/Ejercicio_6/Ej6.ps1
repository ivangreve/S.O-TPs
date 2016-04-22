﻿<#

.SYNOPSIS
El script realiza un backup de un directorio cada una determinada cantidad de tiempo.

.DESCRIPTION
El script realiza un backup de un directorio cada una determinada cantidad de tiempo. Pasandole como parametro el path de entrada, de salida y el intervalo de tiempo.
.PARAMETER pathentrada
El directorio donde se encuentran los archivos que se desea realizar el backup.

.PARAMETER pathdestino
El directorio donde se guardara el backup de los archivos.

.PARAMETER intervalo
El intervalo de tiempo entre backups.

.EXAMPLE
Ej6.ps1 "Path Entrada" "Path Destino" "Intervalo de tiempo"


#>

<#
Nombre del Script: Ej6.ps1
Trabajo Práctico nro 1
Programación de scripts básicos en Powershell
Ejercicio 06

Integrantes del grupo:
Greve Iván - 38617763
Boullon Daniel Ernesto - 36385582
Silvero Heber Ezequiel - 36404597
Valenzuela Juan Santiago - 38624490
Nicolás Satragno - 38527273


Entrega: Primera Entrega
#>

Param
(
   [Parameter(Position = 1, Mandatory = $true)] [String] $pathentrada,
   [Parameter(Position = 2, Mandatory = $true)] [String] $pathdestino,
   [Parameter(Position = 3, Mandatory = $true)] [int] $intervalo
)

$cantPar = ($psboundparameters.Count + $args.Count)
if( $cantPar -ne 3 )
{
  Write-Output "La cantidad parametros fue distinta a 3!"
  exit
}

$existe1 = Test-Path $pathentrada
$existe2 = Test-Path $pathdestino
if($existe1 -eq $true -and $existe2 -eq $true)
{
   $esPathEntrada = (Get-Item $pathentrada) -is [System.IO.DirectoryInfo] 
   $esPathDestino = (Get-Item $pathdestino) -is [System.IO.DirectoryInfo]
   if($esPathEntrada -eq $true -and $esPathDestino -eq $true)
   {
       $pathentrada = Resolve-Path $pathentrada
       $pathdestino = Resolve-Path $pathdestino
   }
   else
   {
     Write-Host algun path recibido como parametro es un archivo
     exit
   }

}
else
{
   Write-Host hay un path inexistente
   exit
}


if($intervalo -le 0)
{
    Write-Host "El intervalo debe ser positivo"
    exit
}




    while(1)
    {
        $fecha = Get-Date -UFormat "%Y-%m-%d_%H_%M_%S"
        $pathbackup = "$pathdestino\$fecha.zip"
        Add-Type -Assembly "System.IO.Compression.FileSystem"
        Get-ChildItem $pathentrada -Recurse -Name
        [io.compression.zipfile]::CreateFromDirectory($pathentrada, $pathbackup)
        Write-Host ""
        Write-Host "El back-up fue realizado con éxito. Se encuentra en $pathbackup"
        
        Wait-Event -Timeout $intervalo
        
          
    }


