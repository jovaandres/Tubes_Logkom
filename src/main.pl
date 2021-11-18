:- dynamic(running/1).
:- dynamic(initialized/1).

:- include('explore_mechanism.pl').
:- include('farming.pl').
:- include('fishing.pl').
:- include('inventory.pl').
:- include('map.pl').
:- include('player.pl').
:- include('quest.pl').
:- include('ranching.pl').

help:-
    initialized(_),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('%                       ~Harvest Star~                     %\n'),
    write('%  1. start  : untuk memulai petualanganmu                 %\n'),
    write('%  2. map    : menampilkan peta                            %\n'),
    write('%  3. status : menampilkan kondisimu terkini               %\n'),
    write('%  4. w      : gerak ke utara 1 langkah                    %\n'),
    write('%  5. a      : gerak ke selatan 1 langkah                  %\n'),
    write('%  6. s      : gerak ke ke timur 1 langkah                 %\n'),
    write('%  7. d      : gerak ke barat 1 langkah                    %\n'),
    write('%  8. help   : menampilkan segala bantuan                  %\n'),
    write('%                                                          %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').

% Inisiasi Game
startGame:-
    initialized(_),
    write('Game has been initialized!'), !.

startGame:-
    \+ initialized(_),
    asserta(initialized(1)),    
    nl, nl, nl,
    write('        ,--,'), nl,
    write('      ,--.\'|                                                    ___'), nl,
    write('   ,--,  | :                                                  ,--.\'|_'), nl,
    write(',---.\'|  : \'             __  ,-.                              |  | :,\''), nl,
    write('|   | : _\' |           ,\' ,\'/ /|    .---.           .--.--.   :  : \' :'), nl,
    write(':   : |.\'  |  ,--.--.  \'  | |\' |  /.  ./|  ,---.   /  /    \'.;__,\'  /'), nl,                                                               
    write('|   \' \'  ; : /       \\ |  |   ,\'.-\' . \' | /     \\ |  :  /`./|  |   |'), nl,
    write('\'   |  .\'. |.--.  .-. |\'  :  / /___/ \\: |/    /  ||  :  ;_  :__,\'| :'), nl,
    write('|   | :  | \' \\__\\/: . .|  | \'  .   \\  \' .    \' / | \\  \\    `. \'  : |__'), nl,
    write('\'   : |  : ; ," .--.; |;  : |   \\   \\   \'   ;   /|  `----.   \\|  | \'.\'|'), nl,
    write('|   | \'  ,/ /  /  ,.  ||  , ;    \\   \\  \'   |  / | /  /`--\'  /;  :    ;'), nl,
    write(';   : ;--\' ;  :   .\'   \\---\'      \\   \\ |   :    |\'--\'.     / |  ,   /'), nl,
    write('|   ,/     |  ,     .-./           \'---" \\   \\  /   `--\'---\'   ---`-\''), nl,
    write('\'---\'       `--`---\'                      `----\''), nl,
    nl, nl,
    write('Harvest Star!!!\n\n'),
    write('Let\'s play and pay our debts together!\n\n'),
    help, !.

assert_run(Job):-
    asserta(running(1)),
    initFishing,
    initFarming,
    initRanch,
    initInventory,
    initPlayer(Job),
    initQuest.

% Mulai game
start:-
    running(_),
    write('The game is currently running!'), !.

start:-
    \+ initialized(_),
    write('Intialized Game First!'), !.

start:-
    \+ running(_),
    initialized(_),
    initMap,
    write('Welcome to Harvest Star. Choose your job\n'),
    write('1. Fisherman\n'),
    write('2. Farmer\n'),
    write('3. Rancher\n'),
    write('> '),
    read(N), nl,
    ((N =:= 1) -> assert_run(fisherman) ;
    (N =:= 2) -> assert_run(farmer) ;
    (N =:= 3) -> assert_run(rancher) ;
    write('Wrong choice!')), !.