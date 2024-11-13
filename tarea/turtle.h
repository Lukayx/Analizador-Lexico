#ifndef TURTLE_H
#define TURTLE_H

#include <SDL2/SDL.h>

// Estructura para almacenar el estado de la "tortuga"
typedef struct {
    int x;
    int y;
    int angle;
    int color;
} Turtle;

// Funciones para manipular la tortuga
void inicializar_turtle(Turtle* turtle);
void cambiar_color(Turtle* turtle, int color);
void mover_a(Turtle* turtle, int x, int y);
void dibujar_linea(Turtle* turtle, int longitud);
void rotar_turtle(Turtle* turtle, int angulo);

// Funciones para manejar SDL
int inicializar_sdl();
void cerrar_sdl();
void dibujar_linea_sdl(int x1, int y1, int x2, int y2, int color);

#endif