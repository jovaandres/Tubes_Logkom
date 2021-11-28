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
        write('This is your last chance, do your best'), nl, !
    ).

dayUpdateNotes:-
    gameover,
    write('You have worked hard, but in the end result is all that matters. May God bless you in the future with kind people!\n'),
    quit.

placeInteract:-
    playerPosition(X, Y),
    (
        questLoc(X, Y) -> write('Quest! Type \'quest\' to request a new quest.\n'), ! ;
        ranchLoc(X, Y) -> write('Check the farm now!\n'), ! ;
        houseLoc(X, Y) -> write('You have had a long day. In house you can:\n'),
                        write('1. sleeping - if you don\'t have insomnia ofc :D\n'),
                        write('2. writeDiary - to capture your moment today.\n'),
                        write('3. readDiary - if you want to nostalgic.\n'), ! ;
        marketLoc(X, Y) -> write('Welcome to the marketplace! Here you can buy or sell items.\n'), ! ;
        planted(Plant, _, X, Y) -> write('Your '), write(Plant), write(' is here.\n'), !;
        diggedTile(X, Y) -> write('You can grow crops here.\n'), ! ;
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
    write('You move east.'), nl, 
    handleMove,
    placeInteract, !.

gameover:-
    nl,
    write('//:::--::://+dMMMMMMMMMMMMMMMNNMMNMMMMNMMNNMNNMMNNNNMMNNMMMMMMMMMMMMNMNMMMMMMMMNNd/:::://///::::----'), nl,
    write('///:::---:/+yNMMMMMMMMMMMMMMNMMMMMMMMNNMMNNMNNMMNNNNNMNNMMMMMMMMMMMMNNNMMNMMMNNNNmy::::////:::------'), nl,
    write('////:::---/sdMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMNNMMNNNNNMMMMMMNMMMMMMNNMNNMMNNMNNNNNmm+::://::::-------'), nl,
    write('::///:::--/yNMMMMMMMMMMMMMMNMMMMMMMMMMMMMMMMNMMMNNNNMMMMMMMNMMMMMNNNMNNMNNNMNNNNNNNh///:::::--------'), nl,
    write(':::///::::/dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNNMMMMMMMMNMMMMMNNNNNNNNNNNNNNNNNNNm//:::::---------'), nl,
    write(':::::::::/+NMMMMMMMMMMMMMMNNMMMMMMMMNMMMMMMMMMMMNNNMMMMMMMNMMMMNNNNNNNNNNNNNNNNNNNmNo/::::----------'), nl,
    write(':::::::::/oNMMNMMMNNMMMMMMNNNMMMMMMNNNMMMMMMMMMMNNMMMMMMNMNMMMNNNNNNNNNNmmNNNNNNNNmNs/::::----------'), nl,
    write('//:::-::::sNMMNNNMMNNNMMMMNNmNMMNNNNNNNNNMMMMMMMNMMMMMMMNMNMMMNNNNNNNNmmmmmmNNNNNNmms/::::----------'), nl,
    write('///:::-::/hNMMMMMMMMNNNNMMMNNNNNNNNmmNNNNNNNNMMMMMMMMMMNNNNMMMNNNNNNNNmmmmmmmNNNNNNm+/:::-----------'), nl,
    write('-:::::---/mMMMMMMMMMMMNNNNNNNNNNmmmmmmNNNNNNNNNMMMMMMMMNMMMMMNNNNNNNmmmmmmmmmNNNNNNmo:::------------'), nl,
    write('`````````-mMMMMMMMMMMMMMMMMMNNNNNNNmNNmmmmNNNNMMMMMMMMMMMMMMMNNNNNNmmmNNNNNmmNNNNNNm+:::------------'), nl,
    write('        `-mNMMMMMMMMMMMMMMMMNNNNNNNNNNmddmmmNNNMMMMMMMMMNNNNNNNmmmmmmNNNNNNNmNNNNNNm+/:-------------'), nl,
    write('        `.dNMMMMMMMMMMMMMMMNNNNMNNNNNNmddddmmNNNNMMMMNNNNNNNNNNNNNNNNNNNNNNmNNNNNNNd/::-------------'), nl,
    write('..``````-/dNMMMMMMMMMMMMMMMNNNMNNNNNNNmmdddmmmNNMMMMMNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd//:-------------'), nl,
    write('........:hmNMMMMMMMMMMMMMMNNNNNNNNNNNNNmmddmmmmNNNNNNNNNNmmmmmNNNNNNNNNNNNNNNNNNNNNm/::-------------'), nl,
    write('.....`..:omNMMMMMMMMMMMMMMNNNNNmmmmdmmmmdddddmmmmmNNNNmmmmmmmmmmNNNNNNNNNNNNNNNNNNNm+:--------------'), nl,
    write('....```.-/yhNMMMMMMMMMMMNNNmmddddhhhhdddhhhhddmmmmmmmmmmmmddmdddmdmmmNNNNNNNNNNNNNNN+:--------------'), nl,
    write('````````.-ohNMMMMMMMMMNNmddhhhhyyyyyyyyyyyyyhddddddmmmmdddddddddddddmmNNNNNNNNNNNNNm+:--------------'), nl,
    write('````````.-/yNMMMMMNNNNddhyyyysssssssssssyyyyyhdddddddddddddhhdhhhddhdmmNNMNNNNNNNNmh/:--------------'), nl,
    write('````````...omNNNNNNNmdhyyssssoososssssssyyyyyyhhhddddddddddhhhhhhdddhddmNNNNNNNNNNmo/:--------------'), nl,
    write('````````..-/dNNNNMMNdyyssooooooossssssyysso+yhyyyyyhhdddddddhhhhhhhddddmmNNNNNNNNmh+::--------------'), nl,
    write('...``````.-:shmNNNNmyssooooooossssoooooo++++ohhhyyyyyhhddmmmmdddhhysydddddmNNNNNmdyo/---------------'), nl,
    write('.....````.--:syhmNmhysooooooooooo+++++++ooooyhhhhhhhhhhhhddhyyyyyhhyyddhyymNNmmmmmho/---------------'), nl,
    write('`.........-.-/+symdysoooooooo+++++++++ooooshddddhhhhhhyyssooooooosyhhhhyyhmNNddddmdy:---------------'), nl,
    write('```.......-..:-/yddssooo++++///+++oooosyhdmmmmmdhyysooooo+++++osyyysooosydmNmmyyhdhy/---------------'), nl,
    write('`````........-:o/shsooo+/////+++ooshdmNNmddhyss+////++ooo+++shhyo++/++osoymmhdhyhhyy:---------------'), nl,
    write('``````......-++/:oyo++////++oosyyhhhyysoo+++/+//////++++osyhyo+/////+os++odhsshhdyoo----------------'), nl,
    write('`````````.../:::-/s++////++oo++++++++++//////++++++++ossso+///////+ss+++/ohyosssmss+----------------'), nl,
    write('``````````.-.----:/+////+++++//////++++////////++oooo++////++++++oo++////+s/+osdhos/----------------'), nl,
    write('```````````.`..---:////+++++++++++++++++++++++++//////////+++oo++//////::+/::/yhy++:::--------------'), nl,
    write('```````````-..-:::///+++++++++++++++++++++++++/////////+++oso+///:/::/::/+:/:/sss+::::--------------'), nl,
    write('```-:/:....---:++///++++++++++++++++++++++++++////+++oooo+///++//////::///:::/+oo/:::::::-----------'), nl,
    write('-.smNN/.....:-:o+///+++++++++++++++++oo++++++++++++ooo+/////++++++//:::///::/:o++::::::::-----------'), nl,
    write('-:mMMh-.....-::+/////+++++++++oooooooooooooooo++++++++///+++++///+/::////::/::so/::---:::-----------'), nl,
    write('-oNMMo.......::://///++++ooo++oooooooooooooo++++//+++++ooo+o+/////::/++/::/::+s/::------------------'), nl,
    write(':syhy:--------//////++++oooo++ooooooo+++++o+++++++++ooo++/+++++//////oo//::-/y+::-------------------'), nl,
    write(':::::-:::::::://///+++ooooo++ooooooooooooooo+++++++++///++ooo++///////++//::ss::--------------------'), nl,
    write(':::::------:///////++oooooo+oooooooooooo+oo+++++//++++++oossoo++///:/:/:/++oh/::::--:::::::---------'), nl,
    write('---::::----://///+++oooooooooooooooooooo+++++++++ooooooooossoo+++ooo+//:::/h/:///////::::::---------'), nl,
    write('-----::::-://////+++ooooooooooooooooooo++osssyyyyyyyhyyyooosooooooooo+++//y:-:::::::--::+y----------'), nl,
    write('-------::://///++++ooooooooooooooooossshdmmmmmddhhyyysoooooooooooo++oooosds+++++/::::/ymNh----------'), nl,
    write('--------:://///+++ooooooooo+++oooosyyyyyhdddddhhhyysooooooooooo++++++++syssosso+//oydNNddh-------:::'), nl,
    write('---------:///+++++oooooooo+++++oooosyhhyyyhhhhyyssoo+++ooooooooo++++++ssssssso+oymNNdyyds----------:'), nl,
    write('---.....-////+++++oo++ooo+++++ossssossyyyyyyyssoo+++ooosssooooo+++++ossossssshmNNdyosdmo------------'), nl,
    write('--.......:///+++++++++++++++/++syyssssssssssssooooosssssoooo++++++ooooosyyhmNNdy++ymNd+-------------'), nl,
    write('-.....--.-+///++++++++++++++/ymyshhyssssssssssssyyysssoooooo+++++oooosyhmNNdy++sdNMms:--------------'), nl,
    write('.........-::/+++++++++++/++++mMMmhhdhyssssosssyyysssooooooo++++oooosyydmds++ohmMMNh/:---------------'), nl,
    write('............:/++++++++++++///odNMMNmdhysssssssyssooooooooooooooosyyyhhs+/ohmMMMNh+::----------------'), nl,
    write('----.........-:/++++++++++/+yo/+ymNMNdhyyssssssooooooooooooossyyyhhy+/ohNMMMMNh+:-------------------'), nl,
    write('-----...........-:/++++++///+dms/:+hNMmhyssssooooooooooossssyyhhhs++ymMMMMNms/::--------------------'), nl,
    write('-----.............-/+++++//:-yMMNh+:/odmyssssoooooooooosssyyhhhsoymMMMMMmy+:::----------------------'), nl,
    write('--------............-://///--/dmNMMmy/:/yysssssooooooosssyhhhyydNMMMMNho/:::-----::-----------------'), nl, nl.