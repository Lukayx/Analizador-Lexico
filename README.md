-Este programa de compila desde Powershell con estos comandos

  flex lex.l
  bison -d ett.y
  g++ -I SDL2/include -L SDL2/lib lex.yy.c ett.tab.c -o traductor -lmingw32 -lSDL2 -lSDL2main

-En caso de cualquier problema una forma alternativa de compilarlo es sin usar MinGW ni GnuWin32 (carpetas de C:)

------------------USANDO MSYS2------------------

MSYS2 es una colección de herramientas y bibliotecas que le brinda un entorno fácil de usar para construir, instalar y ejecutar software de Windows nativo

En este caso ya no sera necesario las carpetas MinGW ni GnuWin32 ya que seran reemplazadas y solo ocuparan espacio en el pc

-Instalar MSYS2:

  https://www.msys2.org //descargar el primer .exe

  Darle a next hasta que salga la opcion de ejecutar MSYS2

-Necesario para usar el programa:

  pacman -Syu
  pacman -S flex bison // instal flex y bison de forma distinta a los instaladores
  pacman -S mingw-w64-x86_64-toolchain //librerias normales
  pacman -S mingw-w64-x86_64-SDL2 //libreria para graficar

-Configurar variables de entorno (PATH):

  C:\msys64\usr\bin //para flex y bison
  C:\msys64\mingw64\bin //librerias en general

//recuerde que si tiene PATHs de MinGW o GnuWin32 entonces debe eliminarlas para no interferir con las nuevas rutas

-Comandos para compilar los archivos:

  flex lex.l
  bison -d ett.y
  g++ lex.yy.c ett.tab.c -o traductor -lmingw32 -lSDL2 -lSDL2main