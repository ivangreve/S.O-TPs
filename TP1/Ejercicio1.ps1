<# Ejercicio 1:

1) El objetivo seria, guardar en un path dado por el par¨¢metro un txt con los procesos,
    pero no lo cumple porque la instrucci¨®n >> guarda el txt en el path actual y no el par¨¢metrisado! 
    para solucionarlo se podr¨ªa agregar la instrucci¨®n set-location $pathsalida luego de validarla. (si no hay parametro lo guarda en el nativo)

2) Que la cantidad no sea mayor a la cantidad de procesos. 
    if( $cantidad-gt $listaproceso.length)
        {
            $cantidad = $listaproceso.length
        }
#>
Param(
[Parameter(Position = 1, Mandatory = $false)][String] $pathsalida = ".",
[int] $cantidad = 3)                       #Declaracion de los parametros: posicion 1, no obligatorio con el path default donde se ejecuta el scrip.
 
$existe = Test-Path $pathsalida            #Verifica si el path ingresado por parametro es valido.

if ($existe-eq $true)                      #Verifica la operacion anterior.
{

$listaproceso = Get-Process                #Guarda en una lista los procesos del sistema.
set-location $pathsalidas                  #Posible solucion para que guarde en el path correctamente aunque cambiaria el path. 
foreach ($proceso in $listaproceso)        #Recorre la lista de prosesos.
{
$proceso | Format-List -Property Id ,Name >> proceso.txt   #Imprime en un txt en formato de lista por id y nombre, 
                                                           #esto lo hace en el directorio nativo y no el path ingresado.                                                        
}
if( $cantidad-gt $listaproceso.length)
{
   $cantidad = $listaproceso.length
}
for ($i  = 0; $i-lt $cantidad ; $i++)                      # Recorre con la condicion de que i sea menor a la cantidad (3 en este caso)
{

Write-Host $listaproceso[$i].Name - $listaproceso[$i].Id     #Imprime en pantalla los primeros 3 procesos con su nombre e ID
}

}else
{
Write-Host "El path no existe" #Si no existe el path de salida Imprime el error.
}

