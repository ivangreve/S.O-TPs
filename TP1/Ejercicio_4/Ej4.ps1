<#
.SYNOPSIS
Muestra los elementos de una colección de objetos que cumplen una condición. 
.DESCRIPTION
Se encarga de mostrar en pantalla las propiedades de una colección de objetos, en base a un valor filtro o sin necesidad de este. Tanto las propiedades, como el filtro y la colección son pasados como parámetros al ejecutar el script. 

.PARAMETER Pipeline
Recibe una colección de objetos.
.PARAMETER Propiedades
Propiedades que debe mostrar de la colección de objetos
.PARAMETER asc
Ordena los resultados finales en forma ascendente
.PARAMETER desc
Ordena los resultados finales en forma descendente
.PARAMETER filtro
Valor que debe filtrar, en las propiedades pasadas cómo parametros.
.EXAMPLE
get-process |.\Ej4.ps1 -propiedades Id,Handles,ProcessName  -asc -filtro 8*
.EXAMPLE 
get-process |.\Ej4.ps1 -propiedades Id -filtro 9*
.EXAMPLE
get-process |.\Ej4.ps1 -propiedades ProcessName 
#>

<#
Nombre del Script: Ej4.ps1
Trabajo Practico nro 1
Programacion de scripts basicos en Powershell
Ejercicio 04

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
    [Parameter(Mandatory=$false,ValueFromPipeline=$True)]$Pipeline,
    [Parameter(Mandatory = $false)][String[]] $propiedades,
    [Parameter(Mandatory = $false)][Switch] $asc,
    [Parameter(Mandatory = $false)][Switch] $desc, 
    [Parameter(Mandatory = $false)][String] $filtro
)
BEGIN
{
   
    $ArrayList = [System.Collections.ArrayList]@()    
   
    if(!$propiedades)
    {
       Write-Host Error. No se paso como parametro la propiedad.
       exit
    } 
    if($asc -eq $true -and $desc -eq $true)
    {
      Write-Host "Error al invocar script" 
      exit
    }
}

PROCESS
{    
    
       foreach ($obj in $Pipeline) 
       {
        $ArrayList.Add($obj)1>$null #Lleno el array con los objetos que van llegando por el pipeline y redireciono salida para que no aparezca en pantalla
       }          
}

END
{   
      if($filtro) # si recibo como parámetro un filtro filtro usare el cmdlet where-object
      {
        if($asc -eq $True)
        {
         foreach($aux in $propiedades)
         {
              echo `n
              write-host resultados propiedad $aux
              $ArrayList   |  Sort-Object -Property $propiedades | Where-Object {$_.$aux -like $filtro} |
              Select-Object $propiedades | Format-Table -AutoSize 
              }       
          }
          else
          {
            if($desc -eq $True)
            {
               foreach($aux in $propiedades)
               {
                  echo `n
                  write-host resultados propiedad $aux
                  $ArrayList  |  Sort-Object -Property $propiedades -Descending| Where-Object {$_.$aux -like $filtro} |
                  Select-Object $propiedades | Format-Table -AutoSize 
              }       
            }
            else
            {
                 foreach($aux in $propiedades)
                 {
                    echo `n
                    write-host resultados propiedad $aux
                    $ArrayList  | Where-Object {$_.$aux -like $filtro} |Select-Object -Property $propiedades | Format-Table -AutoSize               
                 }
            }
          }
      
      }#fin filtro
      else
      {
         if($asc -eq $True)
        {
         
              echo `n
              write-host resultados propiedad $propiedades
              $ArrayList   |  Sort-Object -Property $propiedades | 
              Select-Object $propiedades | Format-Table -AutoSize 
              }       
          
          else
          {
            if($desc -eq $True)
            {
                  echo `n
                  write-host resultados propiedad $propiedades
                  $ArrayList  |  Sort-Object -Property $propiedades -Descending| 
                  Select-Object $propiedades | Format-Table -AutoSize                     
            }
            else
            {
                echo `n
                write-host resultados propiedad $propiedades
                $ArrayList  |Select-Object -Property $propiedades | Format-Table -AutoSize                
            }
      }        
    }
 }
      