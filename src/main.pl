:- dynamic(running/1).
:- dynamic(initialized/1).

:- include('explore_mechanism').
:- include('farming').
:- include('fishing').
:- include('house').
:- include('inventory').
:- include('item').
:- include('map').
:- include('marketplace').
:- include('player').
:- include('quest').
:- include('ranching').

help:-
    initialized(_),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('%                       ~Harvest Star~                         %\n'),
    write('%  1. start      : untuk memulai petualanganmu                 %\n'),
    write('%  2. map        : menampilkan peta                            %\n'),
    write('%  3. status     : menampilkan kondisimu terkini               %\n'),
    write('%  4. w          : gerak ke utara 1 langkah                    %\n'),
    write('%  5. a          : gerak ke selatan 1 langkah                  %\n'),
    write('%  6. s          : gerak ke ke timur 1 langkah                 %\n'),
    write('%  7. d          : gerak ke barat 1 langkah                    %\n'),
    write('%  8. help       : menampilkan segala bantuan                  %\n'),
    write('%  9. questhelp  : menampilkan bantuan quest                   %\n'),
    write('%  10.househelp  : menampilkan perintah di house               %\n'),
    write('%  11.markethelp : menampilkan perintah di marketplace         %\n'),
    write('%  12.farmhelp   : menampilkan perintah untuk farmin           %\n'),
    write('%  13.ranchhelp  : menampilkan perintah untuk ranching         %\n'),
    write('%  14.fishhelp   : menampilkan perintah untuk fishing          %\n'),
    write('%                                                              %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').

questhelp:-
    initialized(_),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('%                                                          %\n'),
    write('%                       ~Quest!!!~                         %\n'),
    write('%  1. quest  : menampilkan informasi quest saat ini        %\n'),
    write('%                                                          %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').

househelp:-
    initialized(_),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('%                                                          %\n'),
    write('%                     ~HOMESWEETHOME~                      %\n'),
    write('%  1. sleeping  : tidur (hari berganti)                    %\n'),
    write('%  2. writeDiary: menuliskan diary                         %\n'),
    write('%  3. readDiary : membaca diary yang sudah pernah ditulis  %\n'),
    write('%                                                          %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').

markethelp:-
    initialized(_),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('%                                                          %\n'),
    write('%                      ~MarketPlace~                       %\n'),
    write('%  1. market  : menampilkan informasi marketplace          %\n'),
    write('%  2. buy     : membeli barang di marketplace              %\n'),
    write('%  3. sell    : menjual barang ke marketplace              %\n'),
    write('%                                                          %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').

farmhelp:-
    initialized(_),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('%                                        %\n'),
    write('%            ~Farming~                   %\n'),
    write('%  1. dig     : menggali tanah           %\n'),
    write('%  2. plant   : menanam tanaman          %\n'),
    write('%  3. harvest : memanen tanaman          %\n'),
    write('%                                        %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').

ranchhelp:-
    initialized(_),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('%                                                          %\n'),
    write('%                       ~Ranching~                         %\n'),
    write('%  1. ranch   : mengecek/mengambil hasil ternak            %\n'),
    write('%                                                          %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').

fishhelp:-
    initialized(_),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'),
    write('%                                    %\n'),
    write('%             ~Fishing~              %\n'),
    write('%  1. fishing : memancing ikan       %\n'),
    write('%                                    %\n'),
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n').

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

quit:-
    running(_),
    retractall(running(_)),
    retractall(initialized(_)),
    retractall(player(_, _, _, _, _, _, _, _, _, _)),
    retractall(playerPosition(_, _)),
    retractall(day(_)),
    retractall(move(_)),
    retractall(maxExp(_)),
    retractall(teleChance(_)),
    retractall(expFarmingReward(_)),
    retractall(planted(_, _, _, _)),
    retractall(inventory(_, _)),
    retractall(countFish(_)),
    retractall(maxCountFish(_)),
    retractall(expFishingReward(_)),
    retractall(listDiary(_)),
    retractall(diggedTile(_, _)),
    retractall(equipments(_, _, _, _, _, _)),
    retractall(currentQuest(_, _, _)),
    retractall(historyQuest(_, _, _)),
    retractall(nQuest(_)),
    retractall(expReward(_)),
    retractall(goldReward(_)),
    write('Thank you!!!').