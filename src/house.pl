:- dynamic(listDiary/1).

listDiary([]).
/***************************** Write Diary *****************************/
fileName(Fname) :-
    day(_X),
    number_atom(_X, _Xatom),
    atom_concat('MyDiary/Day', _Xatom, _Fname1),
    atom_concat(_Fname1, '.txt', Fname).

teleOptions:-
    dimension(X0, Y0),
    questLoc(X1, Y1),
    ranchLoc(X2, Y2),
    houseLoc(X3, Y3),
    marketLoc(X4, Y4),
    X5 is X0 - 1,
    Y5 is Y0 - 1,
    format("Important!!\nYou can only move at coordinates X(1-~w), and Y(1-~w)", [X5 ,Y5]), nl,
    write('Special places:\n'),
    format("Quest : ~w, ~w", [X1, Y1]), nl,
    format("Ranch : ~w, ~w", [X2, Y2]), nl,
    format("House : ~w, ~w", [X3, Y3]), nl,
    format("Market: ~w, ~w", [X4, Y4]), nl.

handleTeleport(X, Y):-
    dimension(A, B),
    \+ bound(X, Y),
    \+ tileAirLoc(X, Y),
    X >= 0, X =< A,
    Y >= 0, Y =< B,
    retractall(playerPosition(_, _)),
    asserta(playerPosition(X, Y)), !.

handleTeleport(_, _):-
    write('You chose the wrong place, your request was rejected!\n'),
    write('Less chance of meeting fairies\n'),
    teleChance(C),
    retractall(teleChance(_)),
    C1 is C + 1,
    asserta(teleChance(C1)).

sleeping :-
    running(_),
    playerPosition(A, O),
    houseLoc(A, O),
    teleChance(C),
    random(0, C, M),
    random(0, C , N),
    write('Sleeping\n'),
    sleep(0.5), 
    write('.\n'),
    sleep(0.5), 
    write('.\n'),
    sleep(0.5), 
    write('.\n'),
    (
        M =:= N -> write('You meet a sleeping fairy. write down the coordinates of where you want to go, and you\'ll get there.\n'),
        teleOptions,
        write('X: '), read(X), nl,
        write('Y: '), read(Y), nl,
        handleTeleport(X, Y),
        placeInteract;
        write('It\'s morning, you wake up with a fresher and more energetic body'), nl
    ),
    asserta(move(15)),
    handleMove, !.

sleeping :-
    running(_),
    write('Are you sure you want to sleep here? Come on! You have your own house.\n').

/* jika diary lebih dari 1 kata maka wajib menggunakan ''. */
writeDiary :-
    running(_),
    playerPosition(A, O),
    houseLoc(A, O),
    day(X),
    fileName(_Fname),
    write('Write your diary for day '), write(X), write(:), nl,
    open(_Fname, write, Stream),
    read(Diary),
    write(Stream, '\''),
    write(Stream, Diary),
    write(Stream, '\''),
    write(Stream, '.'),
    nl(Stream),
    close(Stream),
    listDiary(L),
    append(L, [X], Lnew),
    retractall(listDiary(_)),
    assertz(listDiary(Lnew)), !.

writeDiary :-
    running(_),
    write('You can only write your diary in your house!\n').

/* source: https://www.tutorialspoint.com/prolog/prolog_inputs_and_outputs.htm */
process_file :-
    read(Line),
    Line \== end_of_file, % when Line is not not end of file, call process.
    process(Line).

process_file :- !. % use cut to stop backtracking
 
process(Line):- %this will print the line into the console
    write(Line),nl,
    process_file.

/***************************** Read Diary *****************************/
writeListDiary([],'') :- !.
writeListDiary([H|T], X) :-
    write('- Day '), write(H), nl,
    writeListDiary(T, X).

readDiary :-
    write('Here are the list of your entries'), nl,
    listDiary(L),
    writeListDiary(L, _X), nl,
    write('Which entri do you want to read?'), nl,
    write('> '), read(D),
    number_atom(D, Datom),
    atom_concat('MyDiary/Day', Datom, _Fname1),
    atom_concat(_Fname1, '.txt', Fname),
    see(Fname), process_file, seen.