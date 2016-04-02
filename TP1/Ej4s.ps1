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
Process
{
    

    foreach ($obj in $Pipeline) 
    {
        $ArrayList.Add($obj)

    
    }
    
}

END
{
    if($ordenamiento -eq "desc") #Ordeno de forma descendente segun las propiedades
    {
        $ArrayList | Sort-Object -Property $propiedades -Descending | 
                     Select-Object $propiedades | 
                     Where-Object {$_.$propiedadfiltro -like $filtro} | Format-Table

    }
    else
    {
        if($ordenamiento -eq "asc")
        {
            $ArrayList | Sort-Object -Property $propiedades | 
                         Select-Object $propiedades | 
                         Where-Object {$_.$propiedadfiltro -like $filtro} | Format-Table
            
        }
        else
        {
            $ArrayList | Select-Object $propiedades | 
                         Where-Object {$_.$propiedadfiltro -like $filtro} | Format-Table
        }

    }
}