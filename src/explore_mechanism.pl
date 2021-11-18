% Rules pergantian day
handleMove:-
    day(D),
    move(M),
    M =:= 15,
    NewDay is D + 1,
    retract(day(_)), asserta(day(NewDay)),
    retract(move(_)), asserta(move(0)), 
    resetCountFish,
    updateRanchedItems, 
    updatePlantedItems, !.

handleMove:-
    move(M),
    NextMove is M + 1,
    retract(move(_)), asserta(move(NextMove)), !.    

% Gerak ke atas(w), bawah(s), kiri(a), kanan(d)
w:-
    playerPosition(X, Y),
    YNext is Y - 1,
    (
        bound(X, YNext) -> write('You have reached the map limit!') ;
        tileAirLoc(X, YNext) -> write('You can\'t get into water!!')
    ), 
    nl,
    !.

w:-
    playerPosition(X, Y),
    \+ bound(X, Y - 1),
    YNew is Y - 1,
    handleMove,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(X, YNew)), 
    write('You move north.'), nl,
    !.

s:-
    playerPosition(X, Y),
    YNext is Y + 1,
    (
        bound(X, YNext) -> write('You have reached the map limit!') ;
        tileAirLoc(X, YNext) -> write('You can\'t get into water!!')
    ), 
    nl, 
    !.

s:-
    playerPosition(X, Y),
    \+ bound(X, Y + 1),
    YNew is Y + 1,
    handleMove,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(X, YNew)),  
    write('You move down.'), nl,
    !.

a:-
    playerPosition(X, Y),
    XNext is X - 1,
    (
        bound(XNext, Y) -> write('You have reached the map limit!') ;
        tileAirLoc(XNext, Y) -> write('You can\'t get into water!!')
    ), 
    nl, 
    !.

a:-
    playerPosition(X, Y),
    \+ bound(X - 1, Y),
    XNew is X - 1,
    handleMove,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(XNew, Y)), 
    write('You move west.'), nl,
    !.

d:-
    playerPosition(X, Y),
    XNext is X + 1,
    (
        bound(XNext, Y) -> write('You have reached the map limit!') ;
        tileAirLoc(XNext, Y) -> write('You can\'t get into water!!')
    ), 
    nl, 
    !.

d:-
    playerPosition(X, Y),
    \+ bound(X + 1, Y),
    XNew is X + 1,
    handleMove,
    retract(playerPosition(X, Y)),
    asserta(playerPosition(XNew, Y)),  
    write('You move east.'), nl,
    !.