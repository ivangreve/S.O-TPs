<#
.SYNOPSIS
Muestra el porcentaje ocupado por cada tipo de archivo.

.DESCRIPTION
Muestra el porcentaje ocupado por cada tipo de archivo (determinado por la extensión) en un directorio especifico. Si no se ingresa el path se usara el path relativo.

.PARAMETER path
El directorio del archivo en el que se requiere para obtener los porcentajes de cada tipo de archivo.

.EXAMPLE
.\Ej2.ps1 “ruta_del_directorio”


#>

<#
Nombre del Script: Ej2.ps1
Trabajo Practico nro 1
Programacion de scripts basicos en Powershell
Ejercicio 02

Integrantes del grupo:
Greve Ivan - 38617763


Entrega: Primera Entrega


#>


Param(
  #Este  va a recibir la entrada por pipe si hubiera. Si no, queda en "blanco"
    [Parameter(Position=1, Mandatory = $false)][ValidateNotNullOrEmpty()][String] $path = “.”    
)

#se ve si existe la ruta
if ((test-path -Path $path) -eq $false) {
    write-host "No existe el directorio "
    exit
}

$HashTable = @{}

$contenido = Get-ChildItem $path -File -Recurse #Cargo en contenido todos los archivos del directorio y subdirectorios, omitiendo las carpetas.


$tamtot = 0

foreach($value in $contenido)
{
    $tamtot += $value.Length
}



foreach($obj in $contenido)
{

    
    if($HashTable.ContainsKey($obj.Extension) -eq $false) #Si la extension no existe en el hash table
    {
        
        $HashTable.Add($obj.Extension,($obj.Length*100)/$tamtot) #Agrego elemento al Hash Table utilizando la extensión como Key y voy calculando el porcentaje
        
    }
    else
    {
        $HashTable.Item($obj.Extension) += ($obj.Length*100)/$tamtot #Sumo el porcentaje de cada archivo ya existente en el Hash Table
        
    }

    

}


$HashTable|Format-table @{L='Extension';E={$_.Name}},@{L='Porcentaje';E={$_.Value}} -AutoSize 

