%{
#include <stdio.h>
#include <stdlib.h>
#include "turtle.h"
#include "turtle.tab.h"  // Incluir el archivo de encabezado generado por Bison

extern YYSTYPE yylval;
extern int yyparse(void);

extern Turtle turtle;  // Declarar turtle como extern
%}

%%

"anfang"         { printf("Inicio del programa\n"); inicializar_turtle(&turtle); return ANFANG; }
"farbe"          { printf("Comando de cambio de color\n"); return FARBE; }
"pos"            { printf("Comando de posición\n"); return POS; }
"rec"            { printf("Comando de trazo a la derecha\n"); return REC; }
"lin"            { printf("Comando de trazo a la izquierda\n"); return LIN; }
"ube"            { printf("Comando de trazo hacia arriba\n"); return UBE; }
"unt"            { printf("Comando de trazo hacia abajo\n"); return UNT; }
"wert"           { printf("Comando de asignación\n"); return WERT; }
"ende"           { printf("Fin del programa\n"); return ENDE; }

"rojo"           { yylval.color = 0xFF0000; return COLOR; }
"verde"          { yylval.color = 0x00FF00; return COLOR; }
"azul"           { yylval.color = 0x0000FF; return COLOR; }
"amarillo"       { yylval.color = 0xFFFF00; return COLOR; }
"blanco"         { yylval.color = 0xFFFFFF; return COLOR; }

[A-Z][0-9]*      { strcpy(yylval.id, yytext); printf("Identificador: %s\n", yytext); return ID; }

[0-9]+           { yylval.num = atoi(yytext); printf("Constante entera: %s\n", yytext); return NUMERO; }

"("              { return '('; }
")"              { return ')'; }
","              { return ','; }
"="              { return '='; }

[ \t\n\r]+       { /* Ignorar espacios, tabulaciones y nuevas líneas */ }

.                { printf("Carácter desconocido: %c\n", *yytext); }

%%

int yywrap() {
    return 1;
}