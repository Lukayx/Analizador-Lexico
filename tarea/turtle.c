#include "turtle.h"
#include <math.h>
#include <stdio.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;

void inicializar_turtle(Turtle* turtle) {
    if (turtle == NULL) return;
    turtle->x = 0;
    turtle->y = 0;
    turtle->angle = 0; // Angulo inicial de 0 grados
    turtle->color = 0xFFFFFF; // Color blanco
}

void cambiar_color(Turtle* turtle, int color) {
    if (turtle == NULL) return;
    turtle->color = color;
}

void mover_a(Turtle* turtle, int x, int y) {
    if (turtle == NULL) return;
    turtle->x = x;
    turtle->y = y;
}

void dibujar_linea(Turtle* turtle, int longitud) {
    if (turtle == NULL) return;
    int endX = turtle->x + (int)(longitud * cos(turtle->angle * M_PI / 180.0));
    int endY = turtle->y + (int)(longitud * sin(turtle->angle * M_PI / 180.0));
    
    // Dibujar la línea usando SDL
    dibujar_linea_sdl(turtle->x, turtle->y, endX, endY, turtle->color);
    
    turtle->x = endX;
    turtle->y = endY;
}

void rotar_turtle(Turtle* turtle, int angulo) {
    if (turtle == NULL) return;
    turtle->angle = (turtle->angle + angulo) % 360;
}

int inicializar_sdl() {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        printf("Error al inicializar SDL: %s\n", SDL_GetError());
        return 0;
    }
    window = SDL_CreateWindow("Turtle Graphics", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 800, 600, SDL_WINDOW_SHOWN);
    if (window == NULL) {
        printf("Error al crear la ventana: %s\n", SDL_GetError());
        return 0;
    }
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (renderer == NULL) {
        printf("Error al crear el renderer: %s\n", SDL_GetError());
        return 0;
    }
    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
    return 1;
}

void cerrar_sdl() {
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void dibujar_linea_sdl(int x1, int y1, int x2, int y2, int color) {
    SDL_SetRenderDrawColor(renderer, (color >> 16) & 0xFF, (color >> 8) & 0xFF, color & 0xFF, 255);
    SDL_RenderDrawLine(renderer, x1, y1, x2, y2);
    SDL_RenderPresent(renderer);
}