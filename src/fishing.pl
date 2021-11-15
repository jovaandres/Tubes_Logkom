 /******************** FISHING ********************/
:- dynamic(countFish/1).
:- dynamic(maxCountFish/1).
:- dynamic(inventory/1).
:- dynamic(expFishingReward/1).

/***** FAKTA *****/
expFishingReward(10).
countFish(0).
maxCountFish(3).

inventory([salmon, 0, 0, 200]).
inventory([mackeral, 0, 0, 150]).
inventory([tuna, 0, 0, 175]).

inventory([chicken, 2, 0, 500]).
inventory([sheep, 1, 0, 1000]).
inventory([cow, 3, 0, 1500]).

inventory([egg, 0, 0, 100]).
inventory([wool, 0, 0, 200]).
inventory([susu, 0, 0, 150]).

/***** RULES *****/
fish :-
    countFish(Count),
    maxCountFish(M),
    Count < M,
    !,
    random(0, 3, X),
    checkFish(X).

fish :-
    write('You reached the limit for fishing today...'), nl,
    write('Come again tomorrow :)'), nl.

/* Mengecek jenis ikan apa yang ditangkap, 
   Jika berhasil, maka jumlah ikan di inventory akan bertambah */
checkFish(0) :-
    write('You did not get anything :('), nl,
    write('You gained 5 fishing exp'), nl.

checkFish(1) :-
    expFishingReward(N),
    player(_, _, _, _, LevelFishing, _, _, _, _, _),
    write('You got '), write(LevelFishing), write(' mackeral!!'), nl,
    write('You gained '), write(N), write(' fishing exp!!'),
    inventory([mackeral, Quantity, Level, Price]),
    Quantity1 is Quantity + LevelFishing,
    retractall(inventory([mackeral, _, _, _])),
    assertz(inventory([mackeral, Quantity1, Level, Price])),
    succedFishing.

checkFish(2) :-
    expFishingReward(N),
    player(_, _, _, _, LevelFishing, _, _, _, _, _),
    write('You got '), write(LevelFishing), write(' tuna!!'), nl,
    write('You gained '), write(N), write(' fishing exp!!'),
    inventory([tuna, Quantity, Level, Price]),
    Quantity1 is Quantity + LevelFishing,
    retractall(inventory([tuna, _, _, _])),
    assertz(inventory([tuna, Quantity1, Level, Price])),
    succedFishing.

checkFish(3) :-
    expFishingReward(N),
    player(_, _, _, _, LevelFishing, _, _, _, _, _),
    write('You got '), write(LevelFishing), write(' salmon!!'), nl,
    write('You gained '), write(N), write(' fishing exp!!'),
    inventory([salmon, Quantity, Level, Price]),
    Quantity1 is Quantity + LevelFishing,
    retractall(inventory([salmon, _, _, _])),
    assertz(inventory([salmon, Quantity1, Level, Price])),
    succedFishing.

/* Apabila berhasil menangkap ikan, jumlah ikan tangkapan harian akan ditambah,
   ExpFsihing bertambah, dan jumlah Fishing Quest akan berkurang */
succedFishing :-
    updateCountFish,
    nQuest(X),
    X \= 1,
    !,
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