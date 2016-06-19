cmake_minimum_required (VERSION 2.6)
project (Ejercicio1)

set (CMAKE_CXX_FLAGS "-Wall -std=c++11")

include_directories(${EJERCICIO1_SOURCE_DIR})
link_directories(${EJERCICIO1_SOURCE_DIR})

add_executable (ProcesoPesadoLectura funciones.cpp proceso_lectura.cpp)
add_executable (ProcesoPesadoEscritura funciones.cpp proceso_escritura.cpp)
target_compile_definitions(ProcesoPesadoLectura PRIVATE USAR_FORK)
target_compile_definitions(ProcesoPesadoEscritura PRIVATE USAR_FORK)


find_package(Threads)
add_executable (ProcesoLivianoLectura funciones.cpp proceso_lectura.cpp)
add_executable (ProcesoLivianoEscritura funciones.cpp proceso_escritura.cpp)
target_compile_definitions(ProcesoLivianoLectura PRIVATE USAR_PTHREAD)
target_compile_definitions(ProcesoLivianoEscritura PRIVATE USAR_PTHREAD)
target_link_libraries(ProcesoLivianoLectura ${CMAKE_THREAD_LIBS_INIT})
target_link_libraries(ProcesoLivianoEscritura ${CMAKE_THREAD_LIBS_INIT})

