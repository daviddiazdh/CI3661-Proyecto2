:- dynamic mostro/4.

% mostro(nombre, nivel, atributo, poder).
mostro(mostroUno, 5, luz, 2100).
mostro(mostroDos, 7, luz, 2400).
mostro(mostroTres, 7, viento, 2500).


% +================================================================+
% |                       comparte_arg                             |
% +================================================================+
% Verifica si dos mostros comparten exactamente una caracterísitica
comparte_arg(A, B) :- 
    (arg(2, A, X), arg(2, B, X), arg(3, A, Y1), arg(3, B, Z1), Y1 \= Z1, arg(4, A, Y2), arg(4, B, Z2), Y2 \= Z2, !);
    (arg(3, A, X), arg(3, B, X), arg(2, A, Y1), arg(2, B, Z1), Y1 \= Z1, arg(4, A, Y2), arg(4, B, Z2), Y2 \= Z2, !);
    (arg(4, A, X), arg(4, B, X), arg(3, A, Y1), arg(3, B, Z1), Y1 \= Z1, arg(2, A, Y2), arg(2, B, Z2), Y2 \= Z2, !).


% +================================================================+
% |                    ternaMundoChiquito                          |
% +================================================================+
%  Verifica si tres cartas mostro cumplen con las condiciones de
%  mundo chiquito.
ternaMundoChiquito(M1, M2, M3) :-
    Mostro1 = mostro(M1, _, _, _),
    call(Mostro1),
    Mostro2 = mostro(M2, _, _, _),
    call(Mostro2),
    Mostro3 = mostro(M3, _, _, _),
    call(Mostro3),
    comparte_arg(Mostro1, Mostro2),
    comparte_arg(Mostro2, Mostro3).

% +================================================================+
% |                       mundoChiquito                            |
% +================================================================+
%  Imprime los tríos de cartas mostro que cumplen con la condición
%  de mundo chiquito. La primera carta es la que se revela de la mano, 
%  la segunda es la que se revela del mazo y la  ́ultima es la que 
%  se agrega del mazo a la mano.
mundoChiquito :- 
    forall(ternaMundoChiquito(X,Y,Z),
    format('~w ~w ~w~n', [X,Y,Z])).


% +================================================================+
% |                    is_alphabetic_string                        |
% +================================================================+
%  Verifica si un string está compuesto por caracteres alfabéticos.
is_alphabetic_string(String) :-
    string_codes(String, Codes),
    is_alphabetic_codes(Codes).


% +================================================================+
% |                     is_alphabetic_codes                        |
% +================================================================+
%  Función recursiva que verifica si una lista de caracteres cumple
%  con que cada caracter cumple con ser alfabético.
is_alphabetic_codes([]).
is_alphabetic_codes([Code|Rest]) :-
    is_alphabetic_char_code(Code),
    is_alphabetic_codes(Rest).


% +================================================================+
% |                   is_alphabetic_char_code                      |
% +================================================================+
%  Verifica si un caracter dado cumple con estar en el rango de 
%  ASCII de caracteres alfabéticos.
is_alphabetic_char_code(Code) :-
    Code >= 0'a, Code =< 0'z, !.
is_alphabetic_char_code(Code) :-
    Code >= 0'A, Code =< 0'Z, !.


% +================================================================+
% |                      verificar_unicidad                        |
% +================================================================+
%  Verifica si el nombre de un mostro a ser creado no existe ya en
%  base de conocimientos. En caso de que exista, envía un mensaje de
%  error y falla.
verificar_unicidad(Nombre) :-
    atom_string(NombreAtom, Nombre),
    forall(mostro(X, _, _, _), NombreAtom \= X), !.
verificar_unicidad(_) :-
    format('Error: Ese nombre de mostro ya existe.', []), fail.

% +================================================================+
% |                       verificar_nombre                         |
% +================================================================+
%  Verifica si el nombre cumple con los formatos establecidos:
%    - Comenzar en minúscula.
%    - Ser totalmente alfabético. 
%  En caso de que no cumpla alguna, envía un mensaje de error y falla.
verificar_nombre(Nombre) :-
    string_chars(Nombre, [PrimeraLetra | _]),
    char_type(PrimeraLetra, lower),
    is_alphabetic_string(Nombre), !.
verificar_nombre(_) :-
    format('Error: Ocurrió un error en el formato del nombre.', []),
    fail.

% +================================================================+
% |                        verificar_nivel                         |
% +================================================================+
%  Verifica si el nivel cumple con los formatos establecidos:
%    - Ser un entero.
%    - Estar entre 0 y 13. 
%  En caso de que no cumpla alguna, envía un mensaje de error y falla.
verificar_nivel(NivelStr) :-
    number_string(Nivel, NivelStr),
    integer(Nivel),
    Nivel > 0,
    Nivel < 13, !.
verificar_nivel(_) :-
    format('Error: Ocurrió un error en el formato del nivel.', []),
    fail.

% +================================================================+
% |                      verificar_atributo                        |
% +================================================================+
%  Verifica si el atributo cumple con los formatos establecidos:
%    - Ser alfabético.
%    - Que sea uno de los atributos posibles. 
%  En caso de que no cumpla alguna, envía un mensaje de error y falla.
verificar_atributo(Atributo) :-
    atom_string(AtributoAtom, Atributo),
    memberchk(AtributoAtom, [agua, fuego, viento, tierra, luz, oscuridad, divino]), !.
verificar_atributo(_) :-
    format('Error: Ocurrió un error en el formato del atributo.', []),
    fail.

% +================================================================+
% |                        verificar_poder                         |
% +================================================================+
%  Verifica si el poder cumple con los formatos establecidos:
%    - Ser numérico.
%    - Que sea un múltiplo de 50 y no sea cero. 
%  En caso de que no cumpla alguna, envía un mensaje de error y falla.
verificar_poder(PoderStr) :-
    number_string(Poder, PoderStr),
    integer(Poder),
    Poder \= 0,
    0 is Poder mod 50, !.
verificar_poder(_) :-
    format('Error: Ocurrió un error en el formato del poder.', []),
    fail.

% +================================================================+
% |                         agregarMostro                          |
% +================================================================+
%  Le pide al usuario valores de un nuevo mostro a crear y, una
%  vez que los recibe y verificar el cumplimiento del formato, 
%  agrega el mostro a la base de conocimientos.
agregarMostro :-
    format('Escribe la información de tu carta mostro en el siguiente formato:~n              [nombre] [nivel] [atributo] [poder] ~nFormato: ~n- Respetar los espacios.~n- El nombre iniciado en minúsculas. ~n- Los posibles atributos son agua, fuego, viento, tierra, luz, oscuridad, divino)~n', []),
    read_line_to_string(user_input, Input),
    split_string(Input, ' ', ' ', L),
    (
        length(L, 4), !;
        write('Error: Debe colocar exactamente los cuatro valores indicados en el formato.'), fail
    ),
    [Nombre | TresTokens] = L,
    verificar_nombre(Nombre),
    verificar_unicidad(Nombre), 
    [NivelStr | DosTokens ] = TresTokens,
    verificar_nivel(NivelStr),
    [Atributo | UnToken ] = DosTokens,
    verificar_atributo(Atributo),
    [PoderStr | _] = UnToken,
    verificar_poder(PoderStr),
    atom_string(NombreAtom, Nombre),
    number_string(Nivel, NivelStr),
    atom_string(AtributoAtom, Atributo),
    number_string(Poder, PoderStr),
    Predicado =.. [mostro, NombreAtom, Nivel, AtributoAtom, Poder],
    assertz(Predicado).
