%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ett.tab.h"
%}

%%

"anfang"             { return ANFANG; }
"farbe"              { return FARBE; }
"wert"               { return WERT; }
"ende"               { return ENDE; }
"pos"                { return POS; }
"rec"                { return REC; }
"lin"                { return LIN; }
"ube"                { return UBE; }
"unt"                { return UNT; }

"rojo"               { yylval.str = strdup("rojo"); return ROJO; }
"verde"              { yylval.str = strdup("verde"); return VERDE; }
"azul"               { yylval.str = strdup("azul"); return AZUL; }
"amarillo"           { yylval.str = strdup("amarillo"); return AMARILLO; }
"blanco"             { yylval.str = strdup("blanco"); return BLANCO; }

[A-Z][0-9]           { yylval.str = strdup(yytext); return ID; }

[0-9]+               { yylval.num = atoi(yytext); return CONST; }

"("                  { return '('; }
")"                  { return ')'; }
","                  { return ','; }
"="                  { return '='; }
[ \t\n]+             { /* Ignorar espacios en blanco */ }

.                    { printf("Carácter desconocido: %c\n", *yytext); }

%%

int yywrap() {
    return 1;
}