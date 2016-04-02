<#
.SYNOPSIS
Muestra por pantalla, cada N segundos, un listado de los M procesos que más utilización de CPU tienen.

.DESCRIPTION
Muestra por pantalla, cada N segundos, un listado de los M procesos que más utilización de CPU tienen, especificando por cada uno de ellos la siguiente información:
Identificador (PID) – Nombre – Tiempo de CPU – Memoria (Working Set).
Si N es igual a 0, la información arrojada por el script será estática, es decir, muestra la información y finaliza. En caso de N mayor a cero, la información se actualizará cada N segundos hasta que el usuario decida finalizar con Ctrl-C.

.PARAMETER Mcant
Cantidad de elementos a visualizar en la lista

.PARAMETER Ncant
Tiempo de intervalo entre actualizaciones.

.EXAMPLE
.\Ej5.ps1 "Cantidad de elementos a visualizar" "Tiempo(s)"


#>

<#
Nombre del Script: Ej5.ps1
Trabajo Practico nro 1
Programacion de scripts basicos en Powershell
Ejercicio 05

Integrantes del grupo:
Greve Ivan - 38617763


Entrega: Primera Entrega


#>

Param(
    [Parameter(Mandatory = $true,Position = 1)][String] $Mcant,
    [Parameter(Mandatory = $true,Position = 2)][String] $Nseg
)


while(1)
{
    

    #Obtengo los primeros $Mcant procesos de forma descendente y le coloco alias a las columnas
    
    Get-WmiObject Win32_PerfRawData_PerfProc_Process |
    Sort PercentProcessorTime -descending | 
    Where-Object {$_.IdProcess -ne 0} |
    Select -first $Mcant IDProcess,Name,PercentProcessorTime,WorkingSet | 
    Format-Table @{L='Id';E={$_.IDProcess}},
                 @{L='Name';E={$_.Name}},
                 @{L='CPU';E={$_.PercentProcessorTime}},
                 @{L='WS';E={$_.WorkingSet}} -AutoSize
    

    if($Nseg -eq 0) #Si $Nseg es 0 muestro lista solo 1 vez
    {
        exit
    }

    Start-Sleep -s $Nseg #Espero $Nseg (segndos)

} 