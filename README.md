# Instrucciones de Compilación

Este programa puede ser compilado desde **Powershell** usando MinGW y GnuWin32 o utilizando **MSYS2** como alternativa si se tiene mal configurado su entorno de compilación en powershell.

## - Compilación desde Powershell usando MinGW y GnuWin32

1. flex lex.l
2. bison -d ett.y
3. g++ -I SDL2/include -L SDL2/lib lex.yy.c ett.tab.c -o traductor -lmingw32 -lSDL2 -lSDL2main

_En caso de cualquier problema una forma alternativa de compilarlo es sin usar MinGW ni GnuWin32 (carpetas ubicadas en "C:")_

## - Compilación desde Powershell usando MSYS2

MSYS2 es una colección de herramientas y bibliotecas que le brinda un entorno fácil de usar para construir, instalar y ejecutar software de Windows nativo.

_En este caso ya no sera necesario las carpetas MinGW ni GnuWin32 ya que seran reemplazadas y solo ocuparan espacio en el pc_

### 1. Instalar MSYS2:

1. https://www.msys2.org 
2. Descargar "msys2-x86_64-20241116.exe"
3. Abrirlo y darle a next hasta que salga la opción de ejecutar MSYS2

### 2. Instalacion de librerias y generadores (flex y bison):

- pacman -Syu
- pacman -S flex bison
- pacman -S mingw-w64-x86_64-toolchain (librerias normales)
- pacman -S mingw-w64-x86_64-SDL2 (libreria para graficar)

### 3. Agregar variables de entorno (PATH):

- C:\msys64\usr\bin (para flex y bison)
- C:\msys64\mingw64\bin (librerias en general)

_recuerde que si tiene PATHs de MinGW o GnuWin32 entonces debe eliminarlas para no interferir con las nuevas rutas_

### 4. Comandos para compilar los archivos:

1. flex lex.l
2. bison -d ett.y
3. g++ lex.yy.c ett.tab.c -o traductor -lmingw32 -lSDL2 -lSDL2main
