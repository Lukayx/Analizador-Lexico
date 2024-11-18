%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <map>
#include <string>
#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>


void yyerror(const char *s);
extern int yylex();

std::map<std::string, std::string> symbol_table;

void init_sdl();
void cleanup_sdl();
void handle_events();
void set_color(const char* color);
void set_position(int x, int y);
void draw_rec(int x);
void draw_lin(int x);
void draw_ube(int x);
void draw_unt(int x);
void assign_value(const char* id, const char* value);
void assign_value_int(const char* id, int value);
std::string get_value(const char* id);


SDL_Window* window = nullptr;
SDL_Renderer* renderer = nullptr;
SDL_Color current_color = {0, 0, 0, 255}; 
int current_x = 0, current_y = 0;

%}

%union {
    char* str;
    int num;
}

%token <str> ANFANG ENDE FARBE WERT POS REC LIN UBE UNT
%token <str> ROJO VERDE AZUL AMARILLO BLANCO
%token <str> ID
%token <num> CONST

%type <str> color id
%type <num> const

%%

S: ANFANG {init_sdl(); handle_events();} Instrucciones ENDE { 
    printf("Programa válido\n"); cleanup_sdl(); exit(0); }
 ;
Instrucciones: inst Instrucciones
             | /* vacío */
 ;

inst: inst_farbe
    | inst_pos
    | inst_rec
    | inst_lin
    | inst_ube
    | inst_unt
    | inst_wert
 ;

inst_farbe: FARBE '(' color ')' { set_color($3); }
          | FARBE '(' id ')' { set_color(get_value($3).c_str()); }
 ;

inst_pos: POS '(' id ',' id ')' { 
            set_position(atoi(get_value($3).c_str()), atoi(get_value($5).c_str())); 
          }
        | POS '(' id ',' const ')' { 
            set_position(atoi(get_value($3).c_str()), $5); 
          }
        | POS '(' const ',' const ')' { 
            set_position($3, $5); 
          }
        | POS '(' const ',' id ')' { 
            set_position($3, atoi(get_value($5).c_str())); 
          }
 ;

inst_rec: REC '(' const ')' { draw_rec($3); }
        | REC '(' id ')' { draw_rec(atoi(get_value($3).c_str())); }
 ;

inst_lin: LIN '(' const ')' { draw_lin($3); }
        | LIN '(' id ')' { draw_lin(atoi(get_value($3).c_str())); }
 ;

inst_ube: UBE '(' const ')' { draw_ube($3); }
        | UBE '(' id ')' { draw_ube(atoi(get_value($3).c_str())); }
 ;

inst_unt: UNT '(' const ')' { draw_unt($3); }
        | UNT '(' id ')' { draw_unt(atoi(get_value($3).c_str())); }
 ;

inst_wert: WERT id '=' const { assign_value_int($2, $4); }
         | WERT id '=' color { assign_value($2, $4); }
 ;

color: ROJO { $$ = $1; }
     | VERDE { $$ = $1; }
     | AZUL { $$ = $1; }
     | AMARILLO { $$ = $1; }
     | BLANCO { $$ = $1; }
 ;

id: ID { $$ = $1; }
 ;

const: CONST { $$ = $1; }
 ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

void show_help() {
    printf("Instrucciones:\n");
    printf("- ANFANG: Inicia el programa\n");
    printf("- ENDE: Termina el programa\n");
    printf("- FARBE(c): Establece el color (ROJO, VERDE, AZUL, AMARILLO, BLANCO)\n");
    printf("- POS(x, y): Establece la posicion (x, y)\n");
    printf("- REC(x): Dibuja linea derecha de longitud x\n");
    printf("- LIN(x): Dibuja linea izquierda de longitud x\n");
    printf("- UBE(x): Dibuja linea arriba de longitud x\n");
    printf("- UNT(x): Dibuja linea abajo de longitud x\n");
    printf("- WERT(id = valor): Asigna valor a identificador\n");
    printf("Ejemplo: FARBE(ROJO) POS(100,100) REC(50)\n");
}

int main() {
    show_help();  // Muestra las instrucciones al inicio
    printf("Ingrese instrucciones:\n\n");
    return yyparse();
}

void set_color(const char* color) {
    printf("Fijando color a %s\n", color);
    if (strcmp(color, "rojo") == 0) {
        current_color = {255, 0, 0, 255};
    } else if (strcmp(color, "verde") == 0) {
        current_color = {0, 255, 0, 255};
    } else if (strcmp(color, "azul") == 0) {
        current_color = {0, 0, 255, 255};
    } else if (strcmp(color, "amarillo") == 0) {
        current_color = {255, 255, 0, 255};
    } else if (strcmp(color, "blanco") == 0) {
        current_color = {255, 255, 255, 255};
    }
    SDL_SetRenderDrawColor(renderer, current_color.r, current_color.g, current_color.b, current_color.a);
}

void set_position(int x, int y) {
    printf("Fijando posición a (%d, %d)\n", x, y);
    current_x = x;
    current_y = y;
}

void draw_rec(int x) {
    printf("Dibujando %d trazos hacia la derecha\n", x);
    SDL_SetRenderDrawColor(renderer, current_color.r, current_color.g, current_color.b, current_color.a);
    SDL_RenderDrawLine(renderer, current_x, current_y, current_x + x, current_y);
    current_x += x;
    SDL_RenderPresent(renderer);
}

void draw_lin(int x) {
    printf("Dibujando %d trazos hacia la izquierda\n", x);
    SDL_SetRenderDrawColor(renderer, current_color.r, current_color.g, current_color.b, current_color.a);
    SDL_RenderDrawLine(renderer, current_x, current_y, current_x - x, current_y);
    current_x -= x;
    SDL_RenderPresent(renderer);
}

void draw_ube(int x) {
    printf("Dibujando %d trazos hacia arriba\n", x);
    SDL_SetRenderDrawColor(renderer, current_color.r, current_color.g, current_color.b, current_color.a);
    SDL_RenderDrawLine(renderer, current_x, current_y, current_x, current_y - x);
    current_y -= x;
    SDL_RenderPresent(renderer);
}

void draw_unt(int x) {
    printf("Dibujando %d trazos hacia abajo\n", x);
    SDL_SetRenderDrawColor(renderer, current_color.r, current_color.g, current_color.b, current_color.a);
    SDL_RenderDrawLine(renderer, current_x, current_y, current_x, current_y + x);
    current_y += x;
    SDL_RenderPresent(renderer);
}


void assign_value(const char* id, const char* value) {
    printf("Asignando a %s el valor %s\n", id, value);
    symbol_table[id] = value;
}

void assign_value_int(const char* id, int value) {
    printf("Asignando a %s el valor %d\n", id, value);
    char buffer[20];
    snprintf(buffer, sizeof(buffer), "%d", value);
    symbol_table[id] = buffer;
}

std::string get_value(const char* id) {
    if (symbol_table.find(id) != symbol_table.end()) {
        return symbol_table[id];
    } else {
        printf("Error: identificador %s no definido\n", id);
        return "0";
    }
}

void init_sdl() {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        fprintf(stderr, "Error inicializando SDL2: %s\n", SDL_GetError());
        exit(1);
    }

    int window_x = 550; 
    int window_y = 100;

    window = SDL_CreateWindow("ETT Draw",
                              window_x, window_y,
                              800, 600, SDL_WINDOW_SHOWN);

    if (!window) {
        fprintf(stderr, "Error creando ventana: %s\n", SDL_GetError());
        SDL_Quit();
        exit(1);
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (!renderer) {
        fprintf(stderr, "Error creando renderizador: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        exit(1);
    }

    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255); // Fondo blanco
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
}

void handle_events() {
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT) {
            cleanup_sdl();
            exit(0);
        }
    }
}

void cleanup_sdl() {
    if (renderer) {
        SDL_DestroyRenderer(renderer);
    }
    if (window) {
        SDL_DestroyWindow(window);
    }
    SDL_Quit();
}