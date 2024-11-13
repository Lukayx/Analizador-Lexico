Necesario para usar el programa:

sudo apt install flex
sudo apt install bison
sudo apt-get install libsdl2-dev

Comandos para compilar los archivos:

flex lex.l
bison -d turtle.y
gcc lex.yy.c turtle.tab.c turtle.c -o turtle_program -lSDL2 -lm