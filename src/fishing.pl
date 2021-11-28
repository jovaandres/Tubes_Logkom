 /******************** FISHING ********************/
:- dynamic(countFish/1).
:- dynamic(maxCountFish/1).
:- dynamic(expFishingReward/1).

/***** FAKTA *****/
initFishing:-
    asserta(expFishingReward(10)),
    asserta(countFish(0)),
    asserta(maxCountFish(3)).

/***** RULES *****/
fishing :-
    running(_),
    playerPosition(X, Y),
    aroundTileAir(X, Y),
    countFish(Count),
    maxCountFish(M),
    Count < M,
    !,
    random(0, 4, N),
    checkFish(N), !.

fishing :-
    running(_),
    playerPosition(X, Y),
    aroundTileAir(X, Y),
    write('You reached the limit for fishing today...'), nl,
    write('Come again tomorrow :)'), nl, !.

fishing :-
    running(_),
    write('You can\'t do fishing here!'), nl.

/* Mengecek jenis ikan apa yang ditangkap, 
   Jika berhasil, maka jumlah ikan di inventory akan bertambah */
checkFish(0) :-
    write('You did not get anything :('), nl,
    write('You gained 5 fishing exp'), nl,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    ExpFishing1 is ExpFishing + 5,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing1, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)).

checkFish(1) :-
    expFishingReward(N),
    player(_, _, _, _, LevelFishing, _, _, _, _, _),
    inventory([mackeral, Quantity, Level, Price], X),
    Quantity1 is Quantity + LevelFishing,
    seratusitem(B, LevelFishing), B == 0, !,
    gotFish,
    write('You got '), write(LevelFishing), write(' mackeral!!'), nl,
    write('You gained '), write(N), write(' fishing exp!!'), nl,
    retractall(inventory([mackeral, _, _, _], X)),
    assertz(inventory([mackeral, Quantity1, Level, Price], X)),
    updateGoldFisher,
    succedFishing.

checkFish(2) :-
    expFishingReward(N),
    player(_, _, _, _, LevelFishing, _, _, _, _, _),
    inventory([tuna, Quantity, Level, Price], X),
    Quantity1 is Quantity + LevelFishing,
    seratusitem(B, LevelFishing), B == 0, !,
    gotFish,
    write('You got '), write(LevelFishing), write(' tuna!!'), nl,
    write('You gained '), write(N), write(' fishing exp!!'),
    retractall(inventory([tuna, _, _, _], X)),
    assertz(inventory([tuna, Quantity1, Level, Price], X)),
    updateGoldFisher,
    succedFishing.

checkFish(3) :-
    expFishingReward(N),
    player(_, _, _, _, LevelFishing, _, _, _, _, _),
    inventory([salmon, Quantity, Level, Price], X),
    Quantity1 is Quantity + LevelFishing,
    seratusitem(B, LevelFishing), B == 0, !,
    gotFish,
    write('You got '), write(LevelFishing), write(' salmon!!'), nl,
    write('You gained '), write(N), write(' fishing exp!!'),
    retractall(inventory([salmon, _, _, _], X)),
    assertz(inventory([salmon, Quantity1, Level, Price], X)),
    updateGoldFisher,
    succedFishing.

checkFish(_) :-
    write('Ah, there\'s no room for me to keep the fishes, i should do something with my inventory').
    
/* Apabila berhasil menangkap ikan, jumlah ikan tangkapan harian akan ditambah,
   ExpFsihing bertambah, dan jumlah Fishing Quest akan berkurang */
succedFishing :-
    nQuest(X),
    X \= 1,
    !,
    updateCountFish,
    updateFishQuest,
    updateExpFishing.

succedFishing :-
    updateCountFish,
    updateExpFishing.

/* Mengupdate jumlah ikan yang berhasil ditangkap hari ini */
updateCountFish :-
    countFish(N),
    N1 is N + 1,
    retractall(countFish(_)),
    assertz(countFish(N1)).

/* Mengupdate exp fishing yang didapat */
updateExpFishing :-
    expFishingReward(N),
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    ExpFishing1 is ExpFishing + N,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing1, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    updateLevelFishing(ExpFishing1).

/* Jika spesialisasi fisherman, maka akan mendapatkan tambahan gold sebanyak 20 saat panen */
updateGoldFisher :-
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Job == fisherman,
    GoldPlayer1 is GoldPlayer + 20,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    checkGoal,
    write('Congrats! You got 20 golds as bonus...'), nl.

updateGoldFisher.

/* Apabila exp melebihi batas untuk naik level, level akan terupdate */
updateLevelFishing(Exp) :-
    Exp >= 100,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFishing \= 2,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, 2, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    updateMaxCountFish,
    nl, nl, write('Congratulation!! Your Fishing Level has been upgraded to level 2!!'), nl,
    write('Your current Fishing Exp : '), write(Exp), nl,
    write('Also... Your maximum number of fishing each day has been increase to 5'), nl,
    updateExpFishingReward.

updateLevelFishing(Exp) :-
    Exp >= 200,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFishing \= 3,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, 3, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    updateMaxCountFish,
    nl, nl, write('Congratulation!! Your Fishing Level has been upgraded to level 3!!'), nl,
    write('Your current Fishing Exp : '), write(Exp), nl,
    write('Also... Your maximum number of fishing each day has been increase to 7'), nl,
    updateExpFishingReward.

updateLevelFishing(Exp) :-
    Exp >= 300,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFishing \= 4,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, 4, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    updateMaxCountFish,
    nl, nl, write('Congratulation!! Your Fishing Level has been upgraded to level 4!!'), nl,
    write('Your current Fishing Exp : '), write(Exp), nl,
    write('Also... Your maximum number of fishing each day has been increase to 9'), nl,
    updateExpFishingReward.

updateLevelFishing(Exp) :-
    Exp >= 400,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFishing \= 5,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, 5, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    updateMaxCountFish,
    nl, nl, write('Congratulation!! Your Fishing Level has been upgraded to level 5!!'), nl,
    write('Your current Fishing Exp : '), write(Exp), nl,
    write('Also... Your maximum number of fishing each day has been increase to 11'), nl,
    updateExpFishingReward.

updateLevelFishing(_).
/* Setelah level terupdate, jumlah tangkapan ikan harian juga bertambah */
updateMaxCountFish :-
    maxCountFish(N),
    N1 is N + 2,
    retractall(maxCountFish(_)),
    assertz(maxCountFish(N1)).

/* Setelah level terupdate, Exp Fishing Reward juga bertambah */
updateExpFishingReward :-
    expFishingReward(N),
    N1 is N + 1,
    retractall(expFishingReward(_)),
    assertz(expFishingReward(N1)).

/* Jika berganti hari, jumlah tangkapan ikan harian tereset menjadi 0 */
resetCountFish :-
    retractall(countFish(_)),
    assertz(countFish(0)).

gotFish:-
    nl,                                                             
    write('                            `-//+//-`                                      '), nl,
    write('                         `:sys++/+oyhh+.                                   '), nl,
    write('                        :o/.`       `-+hs.                                 '), nl,
    write('                     `.+ooossyssso+/:-``:y:                                '), nl,
    write('                 `:oyyso+/:-...--:/oyhhhs/o:                               '), nl,
    write('              `:syo:.`     .`      ```.-+yhd/.                             '), nl,
    write('            `+yo-`   `-`   .y  `.  `s    `::oys:`              ``          '), nl,
    write('           :h+.  `    `s-   -   h.  .  .  y  `-os+.          .ohmo         '), nl,
    write('          oy. `/++/-   .d`   `  /  .   o  .  :` `:oo:.    `-yho-Ns         '), nl,
    write('         /h`  /+dm-s    y-   -+    s-  ` `:  :`    `:+o//+ss:` :M.         '), nl,
    write('         h:   `/oo/.    s`   :-    -     -:           `-/:.    od          '), nl,
    write('         +o             :                        .`-:/++/+o/.  +m          '), nl,
    write('          /o-`                             `-`   :y/-`    `/ys-:M.         '), nl,
    write('           `://-.``        ``      `/ ``.-/+ooo/:+o         `/yhm.         '), nl,
    write('               `-----...````+:`     h----.`   `--.             .`          '), nl,
    write('                             :so:--/d`                                     '), nl,
    write('                               .:///`                                      '), nl, nl.