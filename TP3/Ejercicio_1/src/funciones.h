#include <functional>
#include <memory>
#include <time.h>

#ifndef FUNCIONES_H
#define FUNCIONES_H

namespace ejercicio3 {

// Reserva memoria e inicializa el array con valores aleatorios.
std::unique_ptr<int> inicializar_array();

// Procesa el array para lectura, contando la cantidad de pares que tiene.
int procesar_array_lectura(int array[]);

// Procesa el array para escritura, insertando en cada posición un número
// distinto.
int procesar_array_escritura(int array[]);

// Devuelve el tiempo actual en microsegundos (µs).
long get_micro();

// Devuelve los microsegundos en el timeval dado.
long get_micro_desde_timeval(const struct timeval& tiempo);

// Realiza una tarea mediante procesos livianos o pesados de acuerdo a las
// opciones de compilación.
void procesar_tarea(const std::function<int()>& funcion);

// Imprime los datos de uso.
void imprimir_datos_uso(long tiempo_arranque);

}  // namespace ejercicio3

#endif // FUNCIONES_H
