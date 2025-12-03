# Proyecto 2: Mundo Chiquito (CI-3661)

- **Nombres:** (Mauricio Fragachán, Alan Argotte, David Díaz)
- **Carnets:** (20-10265, 19-10664, 20-10019)

---

## Instrucciones de ejecución

El usuario del programa requiere abrir el intérprete de Prolog:

1.  **Abrir el intérprete de Prolog:** `swipl`
2.  **Cargar la base de conocimiento:** `?-[mundo_chiquito_base]`

---

## Explicación de la implementación

Nuestro programa implementa un algoritmo de identificación de tripletas de cartas de mostro del popular juego JCC (Juego de Cartas Colecciones) ***Duelo de cartas de mostro*** que cumplen con la condicion *Mundo Chiquito*. Las cartas de mostro tienen una lista de características que son un *nombre único*, *nivel* (un entero positivo entre 1 y 12), *poder* (un entero múltiplo de 50) y
*atributo* (que puede ser *agua*, *fuego*, *viento*, *tierra*, *luz*, *oscuridad* o *divino*). Resumidamente, nuestro programa en Prolog busca en la base de conocimientos todas las cartas registradas y a través de un recorrido DFS sobre el árbol de búsqueda de todas las 3-combinaciones de cartas X Y Z, todas las cartas X Y Z tales que X y Y y Y y Z comparten exactamente una característica.

La lógica del programa está descrita en el predicado `ternaMundoChiquito/3`, que toma tres
variables formales M1, M2 y M3 que son los nombres de las cartas mostro registradas en la base
de conocimiento y llama a `comparte_arg/2` que determina qué característica es compartida 
exactamente por un par de cartas de mostro. Este es un predicado que es `true` solo si X y Y y Y y Z comparten una y solo una característica (nivel, poder o atributo). `mundoChiquito/0` imprime en el intérprete todas las tripletas de cartas X Y Z que cumplan esta condición. Para agregar una carta de mostro a la base de conocimiento, `agregarMostro/0` solicita al usuario las características de la carta, hace la validación de las entradas y agrega la carta al final de la base de conocimiento.

Entre las verificaciones hechas por `agregarMostro/0` tenemos:
- ***Verificar validez del nombre y unicidad***: `verificar_unicidad/1` y `verificar_nombre/1` verifican que el nombre sea único y que se compone únicamente de caracteres alfabéticos.
- ***Verificar validez del nivel***: `verificar_nivel/1` se encarga de verificar que el usuario dio un tipo numérico entero y que sea un entero entre 1 y 12.
- ***Verificar atributo***: `verificar_atributo/1` verifica si el usuario escribió un atributo válido. Es decir, si es el atributo *agua, fuego, viento, tierra, luz, oscuridad, divino*.
- ***Verificar poder***: `verificar_poder/1` verifica si el poder de la carta es un múltiplo
positivo de 50 distinto de 0.  

## Ejemplo de salida

Dadas las cartas de mostro precargadas en la base de conocimiento
```bash
mostro(mostroUno, 5, luz, 2100).
mostro(mostroDos, 7, luz, 2400).
mostro(mostroTres, 7, viento, 2500).
```
Tras llamar a `mundoChiquito/0`, el usuario ve en la salida estándar
```bash
mostroUno mostroDos mostroTres
mostroTres mostroDos mostroUno
mostroUno mostroDos mostroUno
mostroDos mostroUno mostroDos
mostroDos mostroTres mostroDos
mostroTres mostroDos mostroTres
```
Que corresponden a las tripletas de cartas X Y Z tales que X y Y y Y y Z comparten exactamente una característica.