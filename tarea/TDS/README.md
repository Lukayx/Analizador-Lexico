flex lex.l

bison -d ett.y

g++ lex.yy.c ett.tab.c -o traductor

./traductor

Para ejecutar el programa ejemplo profesora:

anfang  

farbe(rojo)

pos(30,30)

rec(2)

unt(4)

wert B1=1

unt(2)

lin(B1)

rec(3)

wert C3=200

pos(C3,30)

wert D5=verde

farbe(D5)

unt(8)

rec(4)

ende                                 
