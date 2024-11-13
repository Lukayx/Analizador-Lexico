%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <map>
#include <string>


void yyerror(const char *s);
extern int yylex();

std::map<std::string, std::string> symbol_table;

void set_color(const char* color);
void set_position(int x, int y);
void draw_rec(int x);
void draw_lin(int x);
void draw_ube(int x);
void draw_unt(int x);
void assign_value(const char* id, const char* value);
void assign_value_int(const char* id, int value);
std::string get_value(const char* id);
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

S: ANFANG Instrucciones ENDE { printf("Programa válido\n"); }
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

int main() {
    return yyparse();
}

void set_color(const char* color) {
    printf("Fijando color a %s\n", color);
}

void set_position(int x, int y) {
    printf("Fijando posición a (%d, %d)\n", x, y);
}

void draw_rec(int x) {
    printf("Dibujando %d trazos hacia la derecha\n", x);
}

void draw_lin(int x) {
    printf("Dibujando %d trazos hacia la izquierda\n", x);
}

void draw_ube(int x) {
    printf("Dibujando %d trazos hacia arriba\n", x);
}

void draw_unt(int x) {
    printf("Dibujando %d trazos hacia abajo\n", x);
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