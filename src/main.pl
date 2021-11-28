:- dynamic(running/1).
:- dynamic(initialized/1).
:- dynamic(finish/1).

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
    write('%                    ~MarketPlace~                         %\n'),
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
    write('%                    ~Ranching~                            %\n'),
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
    story, 
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
    nl,
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
    (
        finish(_) -> finishgame;
        write('')
    ),
    write('Thank you for playing!!!').

story:-
    nl,
    write('........./+/.........--o+-o//-../-...+:....../:.-/.........................----------------:::::::::::::////////+++oooooooosdddddddddddddddddddddddddd'), nl,
    write('....-....:-+..........--o///-..::....+-....-s-../............................----------------:::::::::::::///////+++ooooooosddddhhdddhhddddddddddddddd'), nl,
    write('-...::-..:.+...........-o+---:::...../.....-/.-:...```.........................---:/::---------::::::::::::://////+++oooooosdddhhhhhhhhhhhhhhhhhhddddd'), nl,
    write('/:../:-::/-/-.........../+...o-....../.....:..+.-:``````````...................-/o/---------------::::::::::///////+++ooooosdddhhhhhhhhhhhhhhhhhhhhddh'), nl,
    write('-+o:o/...-+:+........---:+.../..----:s--.....-s:--`.````````````.-............/syooooo+/:------------:::::::://////+++ooooosdddhhhhhhhhhhhhhhhhhhhhdhd'), nl,
    write('::-:+o-.../o+.......--..//.-:o-::::/+y/::----/..-:-.`````````..--......------+yyssyyyyyyyyo/:::::------::::::///////++++ooosdddhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('.....:o/::::++-....--/:-+::/o+/++oosoyoooo++s/--/:.```````.--:-..-:/+oossssssyyyyyyssssssyhhs+/:---------::::://////++++ooosddhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('......o-.....:+--..--/o/+/+sssssyyhyyyssyyyyyo+o+-...``.----.../osssssssssssssssssyyyssssssys+:----------:::::://///+++++oosddhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('......y:/-----.-:/::::+sssyhyyssyyssyssossyyyyyyso+:--//-.``-+ssssysssssssysssssysssys+/osssyys/---------:::::://////+++++osddhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('......+o//::::::/os/+syyyyyyoo++y+oyos++ooooyosssssso/+..`./sssssyyysyssssyyssssyhyssss/.:sssyhy+---------:::::://///++++++sddhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('......:+-.....-://ssyyssoy+s+//so++s:o::+/+oy/+oooshhs:-..ossyysydhmyyhssssyhysssshssyyy:`.+ssydh+--------:::::://////+++++sddhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('.......//...--//+shhsoo+++o+/+o/--:/-+-:-+:-o://+oshyyo:-syssysydhdddsdhyssshdysssyhhdyhy.``+ssydd+-------:::::://////+++++ohdhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('......../:.-:/+ohhyyo++////s/:--:/yoohyoso-:s--::oossyysyhysyyshmhmyhhhmdyssyddyssshmdydm+./dhssssho-------:::::://////++++ohdhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('.........:+://shhysy+/+/:-:s//oyhyysyyyhhyyyy::-:ys/+oshhhsshyymddhyyhydmmhsshmhssssdddmmhhmmdhyss++o:-----::::::://///++++ohdhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('.........-so+syyssoyo/o:-:/yyyhysooyyyhyysssyyy+:s+++sssydssdyhmhdyyyyhhdhmdyydmyssshmmmmshmmmmdhyyo-:-----::::::://///++++ohdhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('.........:+syhysys++yo/:/oyhsyyoo++oyssoysoosyyhyos++//sydssmydhdysyyyyyhyyhmhdmdssshmmmms/:ohdmmdhys/-----:::::::://///+++ohdhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('-.......-/+shhsssysssho+yyysssyy+//yo+/+o/oooosydhy/://ohdsymhdyysssssssshyyhdmmmysshmmmm+:---:/oyhdhyo:---:::::::://///+++ohdhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('o:...---/+ohdhyso+/::/yhysosy+syo--o-.-:+/:/soyshhy:://+hyysddhyhhhooooooshyysydmhyshdhmd::--------://++:--::::::::://///++oddhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('-----:-:+oyhhyyyo/:--/ddsooss/o/..//`.`:+/::ysyosyh+::/+hssyddd+yhy+++++/++mdd/+myyyhssdo------------------::::::::::////+++hddhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('.......:/oyysssso/::/yhhsssyo/:/..+:-`.o--:/oso+oshs////os/ohmy/yho////////sys//+:sys+/s-------------------::::::::::////+++ddhhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('......-:+oyyssso/---+hssso++//:/:/+:/-//...-o+//++//-:://-``/h+-/o/:::::::::/+:-.-s+/::--------------------::::::::::////+++hddhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('......:+oshhsyso/--/ohsoss/::+//..```.::.....--:-`.-::/:.````.+................`./y:----------------------:::::::::::////+++dddhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('...-::/s+shyssso/-:oshyysss///oo-`````````````-:`````..```````..`````/::::-````.+so+---------------------::::::::::::////+++dddhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('-:/:-://+oyyssso:-/:+ysosho/-:s+.-+o++-...`.../-`````.-.``---``...```+:/++:`.-/ooooo//++-::-------------:::::::::::::////+++dmdhhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('---//:-/+oyyssso/:+-/yysyyo/:+:o/:+o++++////////:::--:::/.:/:`````-/:---::-/+ooooooo:::-``//++++++///////:::::::::::::///+++dmddhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('::/o..-/++yyysss+o:-:odhy/....----------------......````-+//+```.--.-oo++ooooooooo/:.`````.::/sddddhhhyysssoo+/::::::////+++dmddhhhhhhhhhhhhhhhhhhhhhh'), nl,
    write('../:.../++oyysssos++//ohys:-----:::::::::::::::::::---.``:+++-`--.````-+oooo+/:.`-:``````.:.`:/hmmmddddhdhhhhh++:::::////+/+dmddhhddhhhhhhhhhhhhhhhhhh'), nl,
    write('-.+-...:/++yhyysso/---/yhyo::::::///////////////////::-.``//+o:.````````...```````::....:-```-/shddhyhhhhhyyyhho+/:::://///+dmdhhhdddhhhhhhhhhhhhhhhhh'), nl,
    write('--::...-/+osyyyyso+/:/s/+sy+/::///////++++++++++//////:-.`.oos:````````````````````+++:/.````./shhhhyyyyyyysyyhhs++::://///+dddddddddddddddhhhhhhhhhhd'), nl,
    write('--/:-.:o+//+oyhyysoooyyso++o////////++++o++++++++++++//::.`/so.```-..`-..`````````.-os/.`````-/shhhhysssssssyhyhhy++/://///+hddddddddddddddddddddddddd'), nl,
    write('--+--/y+-://osyhdhyhyo///+/+o//////+++osyysy+++++++++++//:..+.```:--:-so+..-.-`````./y-``..``./shhhhdhyyyhhyhyyyyyy+o//////+dddddddddddddddddddddddddd'), nl,
    write('--+/+oo---:++/+sdhysso+//++os+////+++++sosoyos++++++++++//:.--```---:o/s:-/..-``````.+:`:-```./ohyysso+/::--......--/://///+ddhysoosyhdddddddddddddddd'), nl,
    write('-/s:::----:+///+shyyyhysosoyos+///+++++oysssohsy+++oooo++//-.:.``````.`..`.--````````//-:````./+--....`````````````....-/////-.``````-:/oyhhhddddddddd'), nl,
    write('/+:---------:///soshddhysossoss+//++++++oyooshyy++oooooo++//-.:`````````````.````````-+/..````://-.```````````````....--/:.`.-://+//++:`.--:--::///+++'), nl,
    write('/:::::::-:/+///+y/+oyhhyyhdyssso++++++++++oooo++ooooooooo++/:.--``````...--........``-o-:`````-/o:..``.........---::////-``/syys+oo:/yo:+oo++/-----...'), nl,
    write(':::::::://+/::::/::/+ossyhhhhyyso+++++++++++++++oooooooooo+//-.:.```..----..`.```..-.//::`````.//+-.....-----:::-----:/-.`.oyyoss:.:/::./hhhhhyyyo++++'), nl,
    write('::::::::::::::::--::://++ohyyhhyy++++++++++ooooooooooooooo++/:..:``...+/.-.`-.`-````-///-``````:/+::///////::-..``````.:-.`.-/ossoo+:/+oyhhhhhhhs+o+++'), nl,
    write(':::::::::::::::::::::::::+soosssss+++++oooooooooooooooooooo++/-./:-//oo:/:-::.:o+-...-:/-`````-//+/:----------::-------:/:-.```.-.`.-..-:::/o+so+++++o'), nl,
    write('::::::::::::::::::::////++ooossyyyysssssssssssssssssssssssssooo++ooooooosssssssooo/::::::::::/ossyo.....................-////:---......````..``.-/+++o'), nl,
    write('ssoo+///////////++osyyyyssssoooooooosssssssssssssssssssssssssssssssssssssoooo++//:://++ossyyhhhhhho::--------...............----::::::------...---::-:'), nl,
    write('ssyyyyyyyyyyyyyyyysooo+++++++++++/+++++++++++++++++++++++++++++++++/+/////++oosssyyhhhhhhhhdddddhysoossssoooosoo+++++////:::::::--------::::::::::::::'), nl,
    write('++++++++++ooo++++++++++++++++++++++++++++++++++++++++++++///////++oosssyyyyhhhhhdddddddddhhhhhyyyysooosoooooosoooooooosoooooooooooooooooooo+++++//////'), nl, nl,
    write('Claire adalah seorang gadis yang baru saja ditipu oleh seorang kliennya yang hilang begitu saja secara GAIB tanpa membayar proyek yang ia bangun dengan susah payah.'), nl,
    write('Selain menjadi korban penipuan, Claire juga terlilit hutang sebesar 20000 gold yang perlu dilunasi dalam jangka waktu 1 tahun.'), nl,
    write('Oleh karena itu, Claire memutuskan untuk pulang ke kampung halamannya dan melanjutkan usaha tani milik kakeknya untuk bisa melanjutkan hidup dan membayar hutangnya.'), nl.