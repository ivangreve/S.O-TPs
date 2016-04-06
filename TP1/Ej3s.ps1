<#
.SYNOPSIS
Resuelve un sistema de ecuaciones de n variables y n incógnitas.
.DESCRIPTION
Recive un txt con los datos para hacer resolver el sistema de ecuaciones y lo guarda en otro txt de salida.
.PARAMETER path
El directorio del archivo en el que se requiere para sacar los coeficioneste de los datos
( por defecto en la raiz del script con el nombre gauss.txt)
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
[Parameter(Position=1, Mandatory = $false)][ValidateNotNullOrEmpty()][String] $path = "gauss.txt”
)

$array = [System.Collections.ArrayList]@()

$contenido = Get-Content $path

$i = $true

foreach($obj in $contenido)
{
    if($i)
        {
            [int]$N = $obj 
            $i = $false;
        }
    else
        {
            $linea = $obj -split " "
            [int]$array.Add($linea)      
        }
}

write-host "N:"$N;
Write-Host "Matriz: "
write-host $array[0][0]
write-host $array[0][1]
write-host $array[0][2]
write-host $array[1][0]
write-host $array[1][1]
write-host $array[1][2]
write-host $array[2][0]
write-host $array[2][1]
write-host $array[2][2]
write-host " " 

for($j=0;$j-lt$N;$j++)
{
    write $j

    $maxEl=[math]::abs($array[$j][$j]);
    $maxRow=$j
    for($k=$j+1;$k-lt$N;$k++) {
        
        if( [math]::abs($array[$k][$j])-gt$maxEl ){
            $maxEl=$array[$k][$j];
            $maxRow=$j

        }    
    }
    

    for($k=$j;$k-lt$N+1;$k++){
                   
        [int]$temp=$array[$maxRow][$k];
        $array[$maxRow][$k]=$array[$j][$k];
        $array[$j][$k]=$temp;
   
    }
    
    for($k=$j+1;$k-lt$N;$k++){
    
        $c= -$array[$k][$j]/$array[$j][$j];
        for($l=$j;$l-lt$N+1;$l++){
            if($j-eq$l){
                $array[$k][$l]=0
            }else{
                $array[$k][$l]+=$c*$array[$j][$l]
            }
        }
    }
}

write-host $array
