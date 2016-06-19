/**
 * Ejercicio 1
 *
 * Rendimiento de procesos pesados y livianos.
 *
 * Proceso pesado, lectura.
 *
 * Integrantes:
 * Greve Iván - 38617763
 * Boullon Daniel Ernesto - 36385582
 * Silvero Heber Ezequiel - 36404597
 * Valenzuela Juan Santiago - 38624490
 * Nicolás Satragno - 38527273
 */
#include "funciones.h"

#include <memory>

namespace ejercicio3 {

namespace {

// Ejecuta la aplicación.
void run() {
  std::unique_ptr<int> array = inicializar_array();

  long tiempo_arranque = get_micro();

  procesar_tarea(std::bind(procesar_array_escritura, array.get()));

  imprimir_datos_uso(tiempo_arranque);
}

}  // namespace

}  // namespace ejercicio3

int main() {
  ejercicio3::run();
  return 0;
}

