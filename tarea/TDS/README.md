

- **Flex**: Para el análisis léxico.
- **Bison**: Para el análisis sintáctico.
- **g++**: Para compilar el código generado.

## Instrucciones de Ejecución

1. **Compilación de los archivos de código**:


   ```bash
   flex lex.l
   bison -d ett.y
   g++ lex.yy.c ett.tab.c -o traductor
