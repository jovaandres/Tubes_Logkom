:- dynamic(playerPosition/2).
:- dynamic(player/10).
:- dynamic(day/1).
:- dynamic(move/1).
:- dynamic(maxExp/1).
:- dynamic(teleChance/1).

goal(20000).

% Player(Job, Level, Level_Farming, Exp_Farming, Level_Fishing, Exp_Fishing, Level_Ranching, Exp_Ranching, Exp, Gold)
% Inisiasi di posisi 1, 1
initPlayer(Job):-
    asserta(playerPosition(4, 4)),
    asserta(player(Job, 1, 1, 0, 1, 0, 1, 0, 0, 250)),
    asserta(day(1)),
    asserta(move(0)),
    asserta(maxExp(300)),
    asserta(teleChance(2)).

status:-
    player(Job, Level, Level_Farming, Exp_Farming, Level_Fishing, Exp_Fishing, Level_Ranching, Exp_Ranching, Exp, Gold),
    day(Day),
    write('DAY '), write(Day), nl, nl,
    write('Your status: \n'),
    write('Job              : '), write(Job), nl,
    write('Level            : '), write(Level), nl,
    write('Level farming    : '), write(Level_Farming), nl,
    write('Exp farming      : '), write(Exp_Farming), nl,
    write('Level fishing    : '), write(Level_Fishing), nl,
    write('Exp fishing      : '), write(Exp_Fishing), nl,
    write('Level ranching   : '), write(Level_Ranching), nl,
    write('Exp ranching     : '), write(Exp_Ranching), nl,
    write('Exp              : '), write(Exp), nl,
    write('Gold             : '), write(Gold), nl.