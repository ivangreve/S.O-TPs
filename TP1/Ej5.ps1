<#
.SYNOPSIS
Muestra por pantalla, cada N segundos, un listado de los M procesos que más utilización de CPU tienen.

.DESCRIPTION
Muestra por pantalla, cada N segundos, un listado de los M procesos que más utilización de CPU tienen, especificando por cada uno de ellos la siguiente información:
Identificador (PID) – Nombre – Tiempo de CPU – Memoria (Working Set).
Si N es igual a 0, la información arrojada por el script será estática, es decir, muestra la información y finaliza. En caso de N mayor a cero, la información se actualizará cada N segundos hasta que el usuario decida finalizar con Ctrl-C.

.PARAMETER Mcant
Cantidad de elementos a visualizar en la lista, Posicion  1, obligatorio.

.PARAMETER Ncant
Tiempo de intervalo entre actualizaciones, Posicion 2, obligatorio.

.EXAMPLE
.\Ej5.ps1 "Cantidad de elementos a visualizar" "Tiempo(s)"
.\Ej5.ps1 10 5
#>
<#
Nombre del Script: Ej5.ps1
Trabajo Practico nro 1
Programacion de scripts basicos en Powershell
Ejercicio 05
Integrantes del grupo:
Greve Iván - 38617763
Boullon Daniel Ernesto - 36385582
Silvero Heber Ezequiel - 36404597
Valenzuela Juan Santiago - 38624490
Nicolás Satragno - 38527273
Entrega: Primera Entrega
#>
Param(
    [Parameter(Mandatory = $true,Position = 1)] $Mcant,
    [Parameter(Mandatory = $true,Position = 2)] $Nseg
)

if( $Mcant -isNot [int])
{
    write "La cantidad de procesos debe ser un numero entero"
    exit;
}
if( $Nseg -isNot [int])
{
    write "El parametro segundo debe ser un numero entero"
    exit;
}

if( [int]$Mcant -le 0)
{
    write "Cantidad de procesos a mostrar debe ser positiva"
    exit;
} 

if( [int]$Nseg -lt 0)
{
    write "Segundos negativos?..."
    exit;
}

do
{ 
    clear 
    #Obtengo los primeros $Mcant procesos de forma descendente y le coloco alias a las columnas
    Get-WmiObject Win32_PerfRawData_PerfProc_Process |
    Sort PercentProcessorTime -descending | 
    Where-Object {$_.IdProcess -ne 0} |
    Select -first $Mcant IDProcess,Name,PercentProcessorTime,WorkingSet | 
    Format-Table @{L='Id';E={$_.IDProcess}},
                 @{L='Name';E={$_.Name}},
                 @{L='CPU';E={$_.PercentProcessorTime}},
                 @{L='WS';E={$_.WorkingSet}} -AutoSize
    
    Start-Sleep -s $Nseg #Espero $Nseg (segndos)
    

}while($Nseg -ne 0)
