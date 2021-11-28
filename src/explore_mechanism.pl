% Rules pergantian day
handleMove:-
    day(D),
    move(M),
    M =:= 15,
    NewDay is D + 1,
    retract(day(_)), asserta(day(NewDay)),
    retract(move(_)), asserta(move(0)), 
    dayUpdateNotes,
    resetCountFish,
    updateRanchedItems, 
    updatePlantedItems, !.

handleMove:-
    move(M),
    NextMove is M + 1,
    retract(move(_)), asserta(move(NextMove)), !.

dayUpdateNotes:-
    day(D),
    (
        D > 365 -> fail;
        write('')
    ),
    player(_, Level, _, _, _, _, _, _, Exp, Gold),
    write('Day '), write(D), write('!!!'), nl,
    write('Level : '), write(Level), nl,
    write('Exp   : '), write(Exp), nl,
    write('The current total gold collected is '), write(Gold), nl,
    RemainingTime is 365 - D,
    (
        RemainingTime > 0 -> write('You still have '), write(RemainingTime) , write(' day to pay off your debt, if you can\'t... well'), nl, !;
        write('This is your last chance, do your best'), nl
    ).

dayUpdateNotes:-
    write('You have worked hard, but in the end result is all that matters. May God bless you in the future with kind people!\n'),
    quit.

placeInteract:-
    playerPosition(X, Y),
    (
        questLoc(X, Y) -> write('Quest! Type \'quest\' to request a new quest.\n'), ! ;
        ranchLoc(X, Y) -> write('Check the farm now!\n'), ! ;
        houseLoc(X, Y) -> write('You have had a long day. In house you can:\n'),
                        write('1. sleeping - if you don\'t have insomnia ofc :D\n'),
                        write('2. writeDiary - to capture your moment today\n'),
                        write('3. readDiary - if you want to nostalgic\n'), ! ;
        marketLoc(X, Y) -> write('Welcome to the marketplace! Here you can buy or sell items.\n'), ! ;
        diggedTile(X, Y) -> write('You can grow crops here\n'), ! ;
        write('')
    ).  

% Gerak ke atas(w), bawah(s), kiri(a), kanan(d)
w:-
    playerPosition(X, Y),
    YNext is Y - 1,
    (
        bound(X, YNext) -> write('You have reached the map limit!') ;
        tileAirLoc(X, YNext) -> write('You can\'t get into water!!')
    ), nl, !.

w:-
    playerPosition(X, Y),
    \+ bound(X, Y - 1),
    YNew is Y - 1,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(X, YNew)),
    writeMap(0, 0), nl,
    write('You move north.'), nl,
    handleMove,
    placeInteract, !.

s:-
    playerPosition(X, Y),
    YNext is Y + 1,
    (
        bound(X, YNext) -> write('You have reached the map limit!') ;
        tileAirLoc(X, YNext) -> write('You can\'t get into water!!')
    ), nl, !.

s:-
    playerPosition(X, Y),
    \+ bound(X, Y + 1),
    YNew is Y + 1,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(X, YNew)),
    writeMap(0, 0), nl,
    write('You move down.'), nl,
    handleMove,
    placeInteract, !.

a:-
    playerPosition(X, Y),
    XNext is X - 1,
    (
        bound(XNext, Y) -> write('You have reached the map limit!') ;
        tileAirLoc(XNext, Y) -> write('You can\'t get into water!!')
    ), nl, !.

a:-
    playerPosition(X, Y),
    \+ bound(X - 1, Y),
    XNew is X - 1,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(XNew, Y)),
    writeMap(0, 0), nl,
    write('You move west.'), nl, 
    handleMove,
    placeInteract,!.

d:-
    playerPosition(X, Y),
    XNext is X + 1,
    (
        bound(XNext, Y) -> write('You have reached the map limit!') ;
        tileAirLoc(XNext, Y) -> write('You can\'t get into water!!')
    ), nl, !.

d:-
    playerPosition(X, Y),
    \+ bound(X + 1, Y),
    XNew is X + 1,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(XNew, Y)),
    writeMap(0, 0), nl,
    write('You move east.'), nl, 
    handleMove,
    placeInteract, !.