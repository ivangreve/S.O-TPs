<#
Nombre del Script: Ej1.ps1
Trabajo Practico nro 1
Programacion de scripts basicos en Powershell
Ejercicio 01

Integrantes del grupo:
Greve Ivan - 38617763
Boullon Daniel Ernesto - 36385582
Silvero Heber Ezequiel - 36404597


Entrega: Primera Entrega


#>

<#

1) El objetivo sería, guardar en un path dado por parámetro un txt. con los procesos,
    pero no lo cumple porque la instrucción >> guarda el txt en el path actual y no el parametrizado! 
    para solucionarlo se podría agregar la instrucción set-location $pathsalida luego de validarla. (si no existe parametro lo guarda en el nativo)

2) Que la cantidad no sea mayor a la cantidad de procesos. 
    if( $cantidad -gt $listaproceso.length)
        {
            $cantidad = $listaproceso.length
        }
#>
Param(
[Parameter(Position = 1, Mandatory = $false)][String] $pathsalida = ".",
[int] $cantidad = 3)                       #Declaración de los parametros: posición 1, no obligatorio con el path default donde se ejecuta el scrip.
 
$existe = Test-Path $pathsalida            #Verifica si el path ingresado por parametro es válido.

if ($existe-eq $true)                      #Verifica la operación anterior.
{

$listaproceso = Get-Process                #Guarda en una lista los procesos del sistema.
set-location $pathsalidas                  #Posible solución para que guarde en el path correctamente aunque cambiaría el path. 
foreach ($proceso in $listaproceso)        #Recorre la lista de procesos.
{
$proceso | Format-List -Property Id ,Name >> proceso.txt   #Imprime en un txt en formato de lista por Id y Nombre.
                                                           #Esto lo hace en el directorio nativo y no el path ingresado.                                                        
}
if( $cantidad-gt $listaproceso.length)
{
   $cantidad = $listaproceso.length
}
for ($i  = 0; $i-lt $cantidad ; $i++)                      # Recorre con la condición de que i sea menor a la cantidad (3 en este caso)
{

Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id     #Imprime en pantalla los primeros 3 procesos con su nombre e ID
}

}else
{
Write-Host "El path no existe" #Si no existe el path de salida Imprime el error.
}

