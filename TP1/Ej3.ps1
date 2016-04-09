<#
.SYNOPSIS
Resuelve un sistema de ecuaciones de n variables y n incógnitas.
.DESCRIPTION
Recive un txt con los datos para hacer resolver el sistema de ecuaciones y lo guarda en otro txt de salida.
el parametro es -path, debe tener una estructura como la siguiente:
3 (n = cantidad de incognitas)
3 2 1 1   (las tres ecuaciones con los primeros 3 coeficientes y la 4 columna de terminos independientes)
5 3 3 3
1 1 1 0
Devuelve 
.PARAMETER path
El directorio del archivo en el que se requiere para sacar los datos
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
[Parameter(Position=1, Mandatory = $false)][ValidateNotNullOrEmpty()][String] $path = "gauss.txt”,
[Parameter(Position=2, Mandatory = $false)][ValidateNotNullOrEmpty()][String] $pathSalida = "solucion.txt”
)
[reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic") > $log # Incluyo esto para usar la funcion isNumber. 
#antes que nada,antes que todo, se valida el path
$ExistePath = Test-Path $path 
if ($ExistePath -eq $false)
{
     Write-Host "El path de entrada no existe"
     exit;
}
$existe = Test-Path $pathsalida
if ($pathsalida -eq $false)
{
     Write-Host "El path de Salida no existe"
     exit;
}

$array = New-Object System.Collections.ArrayList #Se crea la matriz
$contenido = Get-Content $path #Se agarra el contenido del .txt
$i = $true #variable que usare luego
$ContFilas=0
foreach($obj in $contenido) #foreach para recorrer el $contenido, es un vector de lineas de texto
{
    if($i) #entra solo para agarrar la primera linea osea n.
        {
            if($obj.length -ne 1) 
            {
                write "Primera linea, hay mas de un numero."
                exit;
            }
          

            if( [Microsoft.VisualBasic.Information]::isnumeric($obj) -eq $false) #Uso isnumeric para validar que el n sea numerico.
            {
                write "n no es numerico n = $obj" 
                exit;
            }
              [int]$n = $obj  #guardo n.
              $i = $false; # asi no vuelve a entrar 
        }
    else
        {
            $ContFilas++
            
            $linea = $obj -split " " # separo por espacios la linea de coeficientes asi me agarra cada coeficiente
            
            for($c=0;$c -le $n; $c++)
            {
                if( [Microsoft.VisualBasic.Information]::isnumeric($linea[$c]) -eq $false) #Uso isnumeric para validar que el n sea numerico.
                {
                    write "La fila contiene un caracter no numerico, o formato invalido (mas de un espacio) = $linea" 
                    exit;
                }
            }
            
            if( $linea.length -ne ($n + 1) )
            {
                write "La fila $ContFilas,[$linea]no respeta las dimenciones del n ($n)"
                exit;
            
            }
            $array.Add($linea)      
        }
}
    if($ContFilas -ne $n)
    {
        write "Cantidad de filas ($ContFilas) distinta a la indicada ($n)"
        exit;
    
    }
    
    #para visualizar la matriz a tratar
    Write-Host "Matriz: $n"
    for( $i=0; $i -lt $n; $i++ )
    {
          write-host $array[$i] | format-list #muestro la matriz en forma elegante :3 
    }
   
#Aca esta toda la logica, es logica, no solo explico el codigo.
for( $j=0; $j -lt $n; $j++ )
{
    
    [double]$maxEl=[math]::abs($array[$j][$j]);  #funcion matematicas se usa [math]::funcion, en este caso abs(modulo) y casteo el double.
    [int]$maxRow=$j #tema de logica guardo la columna
    for( $k=($j+1); $k -lt $n; $k++ ) {
        if( [double][math]::abs( $array[$k][$j] ) -gt [double]$maxEl ){
            $maxEl=$array[$k][$j];
            $maxRow=$k
        }  
    }
    
    
    #for 1
    for( $k=$j; $k -lt $n+1; $k++ ) {
                
        [double]$temp=$array[$maxRow][$k];
        $array[$maxRow][$k]=$array[$j][$k]; #Tema de logica son asignaciones 
        [double]$array[$j][$k]=$temp;
   
    }
    
    
    #for 2
    for( $k=$j+1; $k-lt$n;$k++){
        [double]$c= (-[double]$array[$k][$j])/$array[$j][$j];
        for( $l=$j; $l -lt $n+1; $l++ ){
            if( $j -eq $l ){
                $array[$k][$l]=0
            }
            else{
                #Esta linea trajo problemas por el double magico
                $array[$k][$l] = [double]$array[$k][$l] + ($c*$array[$j][$l]) #aca para que funcione la operacion casteamos como double asi lo interpreta matematicamente
            }
        
        }
    }
}
$x=@( for($w=0; $w -lt $n; $w++){0}) #creacion de array para las soluciones
$x
    #para visualizar la matriz triagulada
    Write-Host "Matriz: $n"
    for( $i=0; $i -lt $n; $i++ )
    {
          write-host $array[$i] | format-list #muestro la matriz en forma elegante :3 
    }
#for 3
for( $j=$n-1; $j -ge 0; $j-- ){
    #otra vez el tema del double
    $x[$j]=[double]($array[$j][$n] / $array[$j][$j])
    
            
    for( $k=$j-1; $k -ge 0; $k--){
        #otra ves el tema del double
        [double]$array[$k][$n] = [double]$array[$k][$n] - ([double]$array[$k][$j]*[double]$x[$j])
        
    }
}
    write-host "Solucion" $x |format-list
    
"$x" >$pathSalida
