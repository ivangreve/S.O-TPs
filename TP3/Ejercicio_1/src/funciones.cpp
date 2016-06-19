#include "funciones.h"

#include <iostream>

#include <pthread.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

namespace ejercicio3 {

namespace {

typedef struct rusage Rusage;

// El tamaño del array para testing. En máquinas de 64 bits, da 160Kb.
static const int kArraySize = 40960;

// La cantidad de trabajos que se lanzan para probar los datos.
static const int kCantidadTrabajos = 1000;

#ifdef USAR_PTHREAD
// Realiza la tarea pasada (del tipo std::function<void(int*)>).
void* realizar_tarea_pthread(void* tarea) {
  std::function<int()>* funcion = static_cast<std::function<int()>*>(tarea);
  (*funcion)();

  return nullptr;
}
#endif  // USAR_PTHREAD


}  // namespace

std::unique_ptr<int> inicializar_array() {
  // Creamos el vector en el heap.
  std::unique_ptr<int> array(new int[kArraySize]);

  // Lo inicializamos con valores aleatorios.
  srand(time(nullptr));
  for (int i = 0; i < kArraySize; ++i)
    array.get()[i] = rand() % 100;

  return std::move(array);
}

int procesar_array_lectura(int array[]) {
  int contador = 0;
  for (int i = 0; i < kArraySize; ++i)
    contador += array[i];
  return contador;
}

int procesar_array_escritura(int array[]) {
  for (int i = 0; i < kArraySize; ++i)
    array[i] *= rand() % 100 + 2;
  return kArraySize;
}

long get_micro() {
  struct timespec tiempo_inicial;
  clock_gettime(CLOCK_MONOTONIC_RAW, &tiempo_inicial);
  return tiempo_inicial.tv_sec * 1e6 + tiempo_inicial.tv_nsec / 1e3;
}

long get_micro_desde_timeval(const struct timeval& tiempo) {
  return tiempo.tv_sec * 1e6 + tiempo.tv_usec;
}

void procesar_tarea(const std::function<int()>& funcion) {
  for (int i = 0; i < kCantidadTrabajos; ++i) {
#ifdef USAR_PTHREAD
    pthread_t id_hilo;
    pthread_create(&id_hilo, nullptr, realizar_tarea_pthread,
                   &const_cast<std::function<int()>&>(funcion));
    pthread_join(id_hilo, nullptr);
#endif  // USAR_PTHREAD
#ifdef USAR_FORK
    pid_t id_hijo = fork();
    if (id_hijo) {
      // Proceso padre.
      wait(nullptr);
    } else {
      // Proceso hijo.
      _exit(funcion());
    }
#endif  // USAR_FORK
  }
}


void imprimir_datos_uso(long tiempo_arranque) {
  Rusage datos_uso;
  getrusage(RUSAGE_SELF, &datos_uso);

  long tiempo_total = get_micro() - tiempo_arranque;
  long tiempo_promedio = tiempo_total / kCantidadTrabajos;

  long tiempo_sistema = get_micro_desde_timeval(datos_uso.ru_stime);
  long tiempo_sistema_prom = tiempo_sistema / kCantidadTrabajos;

  long tiempo_usuario = get_micro_desde_timeval(datos_uso.ru_utime);
  long tiempo_usuario_prom = tiempo_usuario / kCantidadTrabajos;

  long size_array = sizeof(int) * kArraySize;

  std::cout
    << "Tamaño del array en bytes         " << size_array            << "  \n"
    << "Tamaño de página del sistema      " << getpagesize()         << "  \n"
    << "Tiempo reloj                      " << tiempo_total          << "µs\n"
    << "Tiempo promedio                   " << tiempo_promedio       << "µs\n"
    << "Tiempo CPU sistema total          " << tiempo_sistema        << "µs\n"
    << "Tiempo CPU usuario total          " << tiempo_usuario        << "µs\n"
    << "Tiempo CPU sistema promedio       " << tiempo_sistema_prom   << "µs\n"
    << "Tiempo CPU usuario promedio       " << tiempo_usuario_prom   << "µs\n"
    << "Soft page faults                  " << datos_uso.ru_minflt   << "  \n"
    << "Hard page faults                  " << datos_uso.ru_majflt   << "  \n"
    << "Señales recibidas                 " << datos_uso.ru_nsignals << "  \n"
    << "Cambios de contexto voluntarios   " << datos_uso.ru_nvcsw    << "  \n"
    << "Cambios de contexto involuntarios " << datos_uso.ru_nivcsw   << "  \n"
    << std::endl;
}

}  // namespace ejercicio3
