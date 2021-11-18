:- dynamic(listDiary/1).

% nanti day nya disesuaiin

listDiary([]).
/***************************** Write Diary *****************************/
fileName(Fname) :-
    day(_X),
    number_atom(_X, _Xatom),
    atom_concat('MyDiary/Day', _Xatom, _Fname1),
    atom_concat(_Fname1, '.txt', Fname).

/* saat ini diary hanya bisa menginput sentence dengan '',
    gunakan '' untuk diary lebih dari 1 kata. */

sleeping :-
    running(_),
    playerPosition(A, O),
    houseLoc(A, O),
    asserta(move(15)),
    handleMove,
    write('.\n'),
    sleep(0.5),
    write('.\n'),
    sleep(0.5),
    write('.\n'),
    write('That\'s a very long night, you can\'t sleep thinking about her.\n'),
    !.

sleeping :-
    running(_),
    write('Are you sure you want to sleep here? Come on! You have your own house.\n').

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

% see('output.txt'), process_file, seen.

% append('output.txt'), write('abc'), write('\n'), write('a'), told.