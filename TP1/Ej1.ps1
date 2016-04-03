<#
Nombre del Script: Ej1.ps1
Trabajo Practico nro 1
Programacion de scripts basicos en Powershell
Ejercicio 01

Integrantes del grupo:
Greve Iv�n - 38617763
Boullon Daniel Ernesto - 36385582
Silvero Heber Ezequiel - 36404597
Valenzuela Juan Santiago - 38624490
Nicol�s Satragno - 38527273

Entrega: Primera Entrega


#>

<#

1) El objetivo ser�a, guardar en un path dado por par�metro un txt. con los procesos,
    pero no lo cumple porque la instrucci�n >> guarda el txt en el path actual y no el parametrizado! 
    para solucionarlo se podr�a agregar la instrucci�n set-location $pathsalida luego de validarla. (si no existe parametro lo guarda en el nativo)

2) Que la cantidad no sea mayor a la cantidad de procesos. 
    if( $cantidad -gt $listaproceso.length)
        {
            $cantidad = $listaproceso.length
        }
#>
Param(
[Parameter(Position = 1, Mandatory = $false)][String] $pathsalida = ".",
[int] $cantidad = 3)                       #Declaraci�n de los parametros: posici�n 1, no obligatorio con el path default donde se ejecuta el scrip.
 
$existe = Test-Path $pathsalida            #Verifica si el path ingresado por parametro es v�lido.

if ($existe-eq $true)                      #Verifica la operaci�n anterior.
{

$listaproceso = Get-Process                #Guarda en una lista los procesos del sistema.
set-location $pathsalidas                  #Posible soluci�n para que guarde en el path correctamente aunque cambiar�a el path. 
foreach ($proceso in $listaproceso)        #Recorre la lista de procesos.
{
$proceso | Format-List -Property Id ,Name >> proceso.txt   #Imprime en un txt en formato de lista por Id y Nombre.
                                                           #Esto lo hace en el directorio nativo y no el path ingresado.                                                        
}
if( $cantidad-gt $listaproceso.length)
{
   $cantidad = $listaproceso.length
}
for ($i  = 0; $i-lt $cantidad ; $i++)                      # Recorre con la condici�n de que i sea menor a la cantidad (3 en este caso)
{

Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id     #Imprime en pantalla los primeros 3 procesos con su nombre e ID
}

}else
{
Write-Host "El path no existe" #Si no existe el path de salida Imprime el error.
}

