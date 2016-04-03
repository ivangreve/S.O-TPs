<#
.SYNOPSIS


.DESCRIPTION


.PARAMETER path


.EXAMPLE



#>

<#
Nombre del Script: Ej4.ps1
Trabajo Practico nro 1
Programacion de scripts basicos en Powershell
Ejercicio 04

Integrantes del grupo:
Greve Ivan - 38617763


Entrega: Primera Entrega


#>



Param(
  #Este  va a recibir la entrada por pipe si hubiera. Si no, queda en "blanco"
    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]$Pipeline=" ",
    [Parameter(Mandatory = $true, Position = 1)][String[]] $propiedades,
    [Parameter(Mandatory = $false, Position = 2)][String] $ordenamiento, 
    [Parameter(Mandatory = $false, Position = 3)][String] $filtro,
    [Parameter(Mandatory = $false, Position = 4)][String] $propiedadfiltro
    
)

BEGIN
{
    $ArrayList = [System.Collections.ArrayList]@()
}

PROCESS
{
    

    foreach ($obj in $Pipeline) 
    {
        $ArrayList.Add($obj) #Lleno el array con los objetos que van llegando por el pipeline
    }
    
}

END
{
    if($ordenamiento -eq "desc") #Ordeno de forma descendente según las propiedades
    {
        $ArrayList | Sort-Object -Property $propiedades -Descending | 
                     Select-Object $propiedades | 
                     Where-Object {$_.$propiedadfiltro -like $filtro} | Format-Table

    }
    else
    {
        if($ordenamiento -eq "asc") #Ordeno de forma ascendente según las propiedades.
        {
            $ArrayList | Sort-Object -Property $propiedades | 
                         Select-Object $propiedades | 
                         Where-Object {$_.$propiedadfiltro -like $filtro} | Format-Table
            
        }
        else #En el caso que no sea ni asc ni desc la lista no se morificará.
        {
            $ArrayList | Select-Object $propiedades | 
                         Where-Object {$_.$propiedadfiltro -like $filtro} | Format-Table
        }

    }
}