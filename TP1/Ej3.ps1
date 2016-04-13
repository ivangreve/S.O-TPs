<#
.SYNOPSIS
Resuelve sistemas de ecuaciones lineales de N ecuaciones por N incognitas        

.DESCRIPTION
Recibe por parametro un archivo txt de entrada con datos para la resolución de un sistema de ecuaciones lineales y guarda la resolución de las incognitas en otro archivo txt de salida.

.PARAMETER in
Para especificar la ubicación del archivo de entrada.
(Por defecto el archivo de entrada es lineal.txt)
El archivo de entrada deber?respetar la siguiente estructura:
		
n (cantidad de incognitas del sistema lineal)
a1 a2 ... an Na
b1 b2 ... bn Nb
.         .  .
.         .  . 
.         .  . 
n1 n2 ... nn Nn
.PARAMETER out
Para especificar la ubicación del archivo de salida.
(Por defecto el archivo de salida es solve.txt)

El archivo de salida tendr?la siguiente estructura:
		
x1 x2 ...  xn (n cantidad de incognitas del sistema lineal)
		
.EXAMPLE
Crear un archivo lineal.txt en el directorio del script con este sistema:
3 
3 2 1 1 
5 3 3 3
1 1 1 0
        
La primera linea corresponde a la cantidad de incognitas del sistema
En las subsiguientes lineas, los valores de las tres ecuaciones con los primeros 3 coeficientes y la cuarta columna con los t閞minos independientes
		
Ejecutar:

.\Ejercicio_3.ps1 -in lineal.txt -out solucion.txt
		
El contenido de solucion.txt ser?

1.5 -2 0.5

En orden los valores de la resolución de cada incognita en una linea
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
[reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic") > $null # Incluyo esto para usar la funcion isNumber. 
#antes que nada,antes que todo, se valida el path
$ExistePath = Test-Path $path 
if ($ExistePath -eq $false)
{
     Write-Warning "El path de entrada no existe"
     exit;
}
$ExistePath = Test-Path $pathsalida
if ($ExistePath -eq $false)
{
     Write-Warning "El path de Salida no existe, se creara uno. ($pathSalida)"
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
                Write-Warning "Primera linea, hay mas de un numero."
                exit;
            }
          

            if( [Microsoft.VisualBasic.Information]::isnumeric($obj) -eq $false) #Uso isnumeric para validar que el n sea numerico.
            {
                Write-Warning  "n no es numerico n = $obj" 
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
                    Write-Warning  "La fila contiene un caracter no numerico, o formato invalido (mas de un espacio) = $linea" 
                    exit;
                }
            }
            
            if( $linea.length -ne ($n + 1) )
            {
                Write-Warning  "La fila $ContFilas,[$linea]no respeta las dimenciones del n ($n)"
                exit;
            
            }
            $array.Add($linea) > $null  #Para que no muestre el contador por consola.
        }
}
    if($ContFilas -ne $n)
    {
        Write-Warning  "Cantidad de filas ($ContFilas) distinta a la indicada ($n)"
        exit;
    
    }
    
    #para visualizar la matriz a tratar
    Write-Host "Matriz($n) a tratar."
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
