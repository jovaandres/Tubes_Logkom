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
    player(_, Level, _, _, _, _, _, _, Exp, Gold),
    day(D),
    write('Day '), write(D), write('!!!'), nl,
    write('Level : '), write(Level), nl,
    write('Exp   : '), write(Exp), nl,
    write('The current total gold collected is '), write(Gold), nl,
    RemainingTime is 365 - D,
    write('You still have '), write(RemainingTime) , write(' day to pay off your debt, if you can\'t... well'), nl.

placeInteract:-
    playerPosition(X, Y),
    (
        questLoc(X, Y) -> write('Quest! Type \'quest\' to request a new quest.\n'), ! ;
        ranchLoc(X, Y) -> write('Check the farm now!\n'), ! ;
        houseLoc(X, Y) -> write('You have had a long day. You can sleep now (if you don\'t have insomnia ofc :D )\n'), ! ;
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
    handleMove,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(X, YNew)), 
    write('You move north.'), nl,
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
    handleMove,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(X, YNew)),   
    write('You move down.'), nl,
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
    handleMove,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(XNew, Y)),  
    write('You move west.'), nl, 
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
    handleMove,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(XNew, Y)),  
    write('You move east.'), nl, 
    placeInteract, !.