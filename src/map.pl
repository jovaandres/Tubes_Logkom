:- dynamic(diggedTile/2).

% Panjang peta tidak termasuk pagar 10 x 15 (dari index 0)
dimension(17, 12).

% Rules buat nandain pagar
bound(X, Y):-
    dimension(A, B),
    (
        X =:= 0; 
        X =:= A;
        Y =:= 0; 
        Y =:= B
    ).

% Lokasi penting di peta
questLoc(8, 2).
ranchLoc(10, 6).
houseLoc(14, 4).
marketLoc(15, 9).
tileAirLoc(4, 8).
tileAirLoc(5, 8).
tileAirLoc(6, 8).
tileAirLoc(3, 9).
tileAirLoc(4, 9).
tileAirLoc(5, 9).
tileAirLoc(6, 9).
tileAirLoc(7, 9).
tileAirLoc(3, 10).
tileAirLoc(4, 10).
tileAirLoc(5, 10).
tileAirLoc(6, 10).

% Jarak ke tile air adalah 1, bukan sqrt(2)
aroundTileAir(X, Y):-
    XPrev is X - 1,
    XNext is X + 1,
    YPrev is Y - 1,
    YNext is Y + 1,
    (
        tileAirLoc(X, YPrev);
        tileAirLoc(X, YNext);
        tileAirLoc(XPrev, Y);
        tileAirLoc(XNext, Y)
    ).

% Buat ngeprint map
writeMap(X, Y):-
    dimension(A, B),
    bound(X, Y),
    write('#'), 
    (
        (X =:= A, Y =:= B) -> ! ;
        (X =:= A) -> nl, Next is Y + 1, writeMap(0, Next), ! ;
        Next is X + 1, writeMap(Next, Y)
    ), !.

writeMap(X, Y):-
    dimension(A, B),
    X \= A, 
    Y \= B,
    (
        playerPosition(X, Y) -> write('P'), ! ;
        questLoc(X, Y) -> write('Q'), ! ;
        ranchLoc(X, Y) -> write('R'), ! ;
        houseLoc(X, Y) -> write('H'), ! ;
        marketLoc(X, Y) -> write('M'), ! ;
        tileAirLoc(X, Y) -> write('o'), ! ;
        diggedTile(X, Y) -> write('='), ! ;
        write('-')
    ),
    Next is X + 1,
    writeMap(Next, Y), !.

map:-
    running(_),
    writeMap(0, 0).

dig:-
    playerPosition(X, Y),
    \+ questLoc(X, Y),
    \+ ranchLoc(X, Y),
    \+ houseLoc(X, Y),
    \+ marketLoc(X, Y),
    \+ tileAirLoc(X, Y),
    \+ diggedTile(X, Y),
    asserta(diggedTile(X, Y)),
    write('You have dug, this place can be planted\n'), !.

dig:-
    write('You can\'t dig here!\n').

initMap:-
    asserta(diggedTile(0, 0)).