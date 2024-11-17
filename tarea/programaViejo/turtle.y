%{
#include "turtle.h"
#include <stdio.h>
#include <string.h>

extern int yylex(void);
extern void yyerror(const char *s);

Turtle turtle;  // Definir la variable turtle
%}

%union {
    int num;
    int color;
    char id[3];
}

%token ANFANG ENDE
%token <num> NUMERO
%token <color> COLOR
%token <id> ID
%token FARBE POS REC LIN UBE UNT WERT
%type <num> color

%%

programa:
    ANFANG instrucciones ENDE {
        printf("Programa terminado.\n");
    }
    ;

instrucciones:
    instrucciones instruccion
    |
    ;

instruccion:
    FARBE '(' color ')' {
        cambiar_color(&turtle, $3);
        printf("Color cambiado a: %d\n", $3);
    }
    | POS '(' NUMERO ',' NUMERO ')' {
        mover_a(&turtle, $3, $5);
        printf("Moviendo a posición (%d, %d)\n", $3, $5);
    }
    | REC '(' NUMERO ')' {
        turtle.angle = 0;  // Ángulo para derecha
        dibujar_linea(&turtle, $3);
    }
    | LIN '(' NUMERO ')' {
        turtle.angle = 180;  // Ángulo para izquierda
        dibujar_linea(&turtle, $3);
    }
    | UBE '(' NUMERO ')' {
        turtle.angle = 90;  // Ángulo para arriba
        dibujar_linea(&turtle, $3);
    }
    | UNT '(' NUMERO ')' {
        turtle.angle = 270;  // Ángulo para abajo
        dibujar_linea(&turtle, $3);
    }
    | WERT ID '=' NUMERO {
        printf("Asignación de valor: %s = %d\n", $2, $4);
        // Almacena el valor en una estructura si se requiere mantener el estado
    }
    | WERT ID '=' COLOR {
        printf("Asignación de color: %s = %d\n", $2, $4);
        // Almacena el color en una estructura si se requiere mantener el estado
    }
    ;

color:
    COLOR { $$ = $1; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    if (!inicializar_sdl()) {
        return -1;
    }
    inicializar_turtle(&turtle);  // Inicializa el estado de la tortuga
    yyparse();                    // Inicia el análisis léxico y sintáctico

    // Bucle de eventos SDL para mantener la ventana abierta
    SDL_Event e;
    int quit = 0;
    while (!quit) {
        while (SDL_PollEvent(&e) != 0) {
            if (e.type == SDL_QUIT) {
                quit = 1;
            }
        }
    }

    cerrar_sdl();                 // Cierra SDL y libera recursos
    return 0;
}