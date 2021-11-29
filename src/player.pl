:- dynamic(playerPosition/2).
:- dynamic(player/10).
:- dynamic(day/1).
:- dynamic(move/1).
:- dynamic(maxExp/1).
:- dynamic(teleChance/1).

goal(20000).

% Player(Job, Level, Level_Farming, Exp_Farming, Level_Fishing, Exp_Fishing, Level_Ranching, Exp_Ranching, Exp, Gold)
% Inisiasi di posisi 4, 4
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

checkGoal:-
    player(_, _, _, _, _, _, _, _, _, Gold),
    goal(G),
    Gold >= G,
    write('Congratulations! You have finally collected 20000 golds!\n'),
    write('Continue playing?'), nl,
    write('1. Yes'), nl,
    write('2. No (Default)'), nl,
    write('>> '), read(Y),
    (
        Y == 1 -> asserta(finish(1));
        finishgame, quit
    ).

checkGoal.

finishgame:-
    nl,
    write('`````````````````````.::+ooysooshhyddddddddddddddddmddddddhyyyyss+/-.```              ``````` ``````'), nl,
    write('```````````````````.-:/+o//yyyhddddddddddddhdmmddmmmmmmdddddddhhhs+:-.```               ````````````'), nl,
    write('``````````````````-:+osysoohdddddddmmmmmmmmmmmdddddmmmmmmmmmmddhyyo/::-````           ``````````````'), nl,
    write('`````````````````./+ossyyyyhddmmmmmmmmmmmmmmmdddddddddddddddhdddddhyo+/-.````       ````````````````'), nl,
    write('````````````````.-syyhhddhddmmmmmmmmmmmmmmmmmmmddddhhhhhdddddddddddhyyso-.```````  `````````````````'), nl,
    write('````````````````-+yhhhhddddmmmmmmmmmmmmmmmmmmmmdddhyyyyhhhhddddddddhhhys/.`````         ````````````'), nl,
    write('```````````````.-shddhhddmmmmmmmmmmmdmmmmmmdmmddhhysssssyyyhhhhhhhhhhhyyo/.`````` ``  ``````````````'), nl,
    write('```````````````-/yhddddddmmmmmmmmdmddmmmmmmdddhhysoooo+ooosssyyyyyyyyyyhys/.````````````````````````'), nl,
    write('``````````````.-shhddddmmmmmmmmdddmddmmmdmdddhysooo+++////+++oooooooooosyyo:-`````````  ````````````'), nl,
    write('``````````````./ydddddmmmmmmmmmddmmmdmmmddddhsso+++/////////////////////oyy+:.```````     ``````````'), nl,
    write('`````````````.-oyddmmmmmmmmmmmmddmmmdmmmddhysoo+++/////::::::::::://///:/ys+/-.``````      `````````'), nl,
    write('`````````````.+syddmmmmmmmmmmmmmmmmmmmdddyso++++///////::::::::::::::::::o/-:-.``````       ````````'), nl,
    write('`````````````-ssshdmmmmmmmmmmmmmmmmmmddhsoo++++///////::::::::::::::::::::-..-```````     ``````````'), nl,
    write('````````````.:sssyhdmmmmmmmmmmmmmmmmhysoo++++++///////:::::::::::::::::::--`.-```````     ``````````'), nl,
    write('```````````..:yhhhddmmmmmmmmmmmmmmdysoo+++++++++++++++/////::::::://+oosso/...```````     ``````````'), nl,
    write('`````````````-yhdddddmmmNNmmmmmmmdysoo+++++oossyyyyyyso+///:::::://+oo++///.```````````  ```````````'), nl,
    write('````````````.-yhdddddddmmNmmmmmmdhso+++++osyssoo+++++/////::::::::///+oo+/-`````````````````````````'), nl,
    write('```````````..-ydddho/+shdmmmmmmddhso++++++++++++oooo++/////:::::://sddy+ss:`````````````````````````'), nl,
    write('`````````....-ydddy:+++oshdddddddhso+++/////+oydmmmyoso////::::://sddhs++/:.````````````````````````'), nl,
    write('..........---:ydddh+o/+ooossyhdddhs+++////+oydhdmmds/oso/+//:::://oo++///:--````````````````````````'), nl,
    write('------------:ohddmms//oossoooydddhs++/////++ooooooo+++++/++//::::///////:::-.```````````````````````'), nl,
    write('::-::::::::/+ydmmmmd/+ssssyosydddhs++/////////////////////++///::::::::::::--```````````````````````'), nl,
    write(':::::::::/+oshdmmmmms+ossyyshhddhyo+/////////////////::///++///:::::::::::::-```````````````````````'), nl,
    write('////::://++oyddmmmmmmo+++ohhhyyyhyo+///////////:::::::::////////::::::::::::-.``````````````````````'), nl,
    write('////::/++++shdmmmmmNNms++yhyssosyso+///////////:::::::::/+++++//:::::::::::::.``````````````````````'), nl,
    write('///::////+oydmmmmmNNNNNdyhsooooosso+///////////::::::::/++//////::::://:::::-```````````````````````'), nl,
    write('////////++shddmmmmNNNNNmds+yyo++oo++//////////::::::::://///++//::::::://:::.``````````````````.....'), nl,
    write('///////++oyddmmmmNNNNNNmmhhmmho+++++/////////:::::::://///////////::::://::.``````````````````......'), nl,
    write('///////++sddmmmmNNNNNNmmmmmmmmh+++++/////////::::::////////////++++oo///::.```.....```````````......'), nl,
    write('///////+shddmmmmNNNNNNNmmmmmmmmho++++/////////::://++++++oooo+o+///y+//:-.`...........```````.......'), nl,
    write('///////shhdmmmmNNNNNNNNNmmmmmmmdyo++++////////:::/ohysoo:/:/:::::/o+:::-............................'), nl,
    write('//////osydddmmNNNNNNNNNNNmmmmmmddso++++////////:///+syyhsso+++oooo+::::-----------------............'), nl,
    write('/////+ssyhhdmNNNNNNNNNNNNmmmmmdddysoo++++////////////+oossssssooo+/:::////////::::::::----..........'), nl,
    write('/////oooysymmNNNNNNNNNNNmmmmmddhdhsoooo++++//////////////+++++///::::++++++++++++////::-------.....-'), nl,
    write('////+++osydmmNNNNNNNNNmhyhdmdhhhhhsooooo+++++///////////////::::::::/+++++++++++/////::-------------'), nl,
    write('+++++++sshddmNNNNNNNNdyosoydhhhhyysooooo+++++++///////////::::::::::+ooooo++++///////::-------------'), nl,
    write('+++++++sshhdmNNNNNNmhso++++oyyyyyyssoooo++++++++++//////:::::::::::/++++++++////::///:::------------'), nl,
    write('+++++++osyhmmNNNNNmyo+////////osssssoo++++++//////++////:::::::::-..-----------...:///::::----------'), nl,
    write('+++++++osshdmNNNNmmh+////:::::::/osssoo++++/////////////::::/+o+-.--/+/:-.......--///////:::::::::::'), nl,
    write('o++++++oooydmmmmdyso/::::::::::::::/+oo+++////////::::::-...:odmmy/::/sddy+:------//++++////////////'), nl,
    write('++++++++ooshmmmm+//////:://///:::::::/+o++/////:::::::::-...--/hmmmh/:/+hmmh+----...-/++/+++++++ooos'), nl,
    write('++++++++++oydmmmddddddhyo/::::////::::://+/////:::::::::-------:ymmmd+//+hmNms---..---::///++++oooss'), nl,
    write('+++++++++++ohhdddmmmmmNNmds+::::////:::::://///::::::::+:-------:ymmmdo//+hmmmo:---..-----:/++ooosss'), nl,
    write('++++++++++///:///+oossddmNNmds+/:::://::---:://::::::::o+--------:hmmmd+//+hmmdo::---------:+oosssyy'), nl,
    write('ooo+++++////++++++++++++sshdmmmdy+::::/::----:::::::://os:--------/hmmmh///odmmd/::---------/ssyyyyh'), nl,
    write('ooo+///:/+osyddmddddhyysoo+ooshdmmh+:::::------::::////+s/---------+dmmds///ymmms::::------:+syyyyhh'), nl,
    write('so/:--..-:::/+ooooo+//++osssoo+syhdmh+::::--------::://+o/:--------:smmmdo//+hmmy:::----://ossyyyyyy'), nl,
    write('::-:---:///::::---:::::::::::::/+ooyhdy+:::----------:/+o+:---------:hmmmh+//odmh:::------:oosssssss'), nl,
    write('-:---:/++::::::-:::::::::::::::::::::+sds/::-----------:/++:---------/dmmmy///hmd+:::------::+osssss'), nl,
    write('--:::/++::::::::::::::::::::::::::::---shho:::------------::----::::::odmmdo//smmy::::--------/ooooo'), nl,
    write('::::///:::::::::::::://:::::/++::::::::+yosy/:------------------:::::::smmmh//+dmh/::::-------:+++oo'), nl,
    write(':::::::::::://////::://:::::+::::::::::-+s/oys/::-----------::--::::::::smmmo//hmd/:::::::-::--/+++o'), nl, nl,
    write('You have won the game and paid the debt.'), nl.