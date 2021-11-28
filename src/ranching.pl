/******************** RANCHING *********************/
:- dynamic(ranchedItems/1).
:- dynamic(expRanchingReward/1).

/***** FAKTA *****/
initRanch:-
    asserta(expRanchingReward(10)),
    asserta(ranchedItems([egg, 3])),
    asserta(ranchedItems([wool, 10])),
    asserta(ranchedItems([susu, 5])).

/***** RULES *****/
/*kalo running -- ranchloc diapus, bisa bisa ajaa
  tapii kalo ga masii error*/
ranch :-
    running(_),
    playerPosition(X, Y),
    ranchLoc(X, Y), 
    write('What do you want to ranch?'), nl,
    write('1. Chicken'), nl,
    write('2. Sheep'), nl,
    write('3. Cow'), nl,
    write('>> '),
    read(C),
    ranching(C), !.

ranch :-
    running(_),
    write('You can\'t do ranch here!\n').

/* Apabila hasil ternak bisa diambil, jumlah hasil ternak pada inventory bertambah,
   player mendapatkan ranching exp tambahan, waktu hewan ternak berproduksi akan direset ke awal.
   Jika hasil ternak belum bisa diambil, akan ada pesan berapa lama lagi hasil ternak bisa diambil */
ranching(1) :-
    ranchedItems([egg, RemainingTime]),
    RemainingTime == 0,
    !,
    inventory([chicken, ChickenQuantity, _, _], X),
    inventory([egg, EggQuantity, Level, Price], X),
    player(_, _, _, _, _, _, LevelRanching, _, _, _),
    ChickenQuantity1 is ChickenQuantity * LevelRanching,
    EggQuantity1 is EggQuantity + ChickenQuantity1,
    retractall(inventory([egg, _, _, _], X)),
    assertz(inventory([egg, EggQuantity1, Level, Price], X)),
    expRanchingReward(N),
    write('Your each chicken lays '), write(LevelRanching), write(' eggs..'), nl,
    write('You got '), write(ChickenQuantity1), write(' eggs!!'), nl,
    write('You gained '), write(N), write(' ranching exp!!'), nl,
    updateEggsQuest,
    updateExpRanching,
    updateGoldRancher,
    retractall(ranchedItems([egg, _])),
    assertz(ranchedItems([egg, 3])).

ranching(1) :-
    ranchedItems([egg, RemainingTime]),
    write('Your chicken has not produced any egg yet :('), nl,
    write('It will lay some eggs in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.

ranching(2) :-
    ranchedItems([wool, RemainingTime]),
    RemainingTime == 0,
    !,
    inventory([sheep, SheepQuantity, _, _], X),
    inventory([wool, WoolQuantity, Level, Price], X),
    player(_, _, _, _, _, _, LevelRanching, _, _, _),
    SheepQuantity1 is SheepQuantity * LevelRanching,
    WoolQuantity1 is WoolQuantity + SheepQuantity1,
    retractall(inventory([wool, _, _, _], X)),
    assertz(inventory([wool, WoolQuantity1, Level, Price], X)),
    expRanchingReward(N),
    write('Your each sheep produces '), write(LevelRanching), write(' wools..'), nl,
    write('You got '), write(SheepQuantity1), write(' wools!!'), nl,
    write('You gained '), write(N), write(' ranching exp!!'), nl,
    updateExpRanching,
    updateGoldRancher,
    retractall(ranchedItems([wool, _])),
    assertz(ranchedItems([wool, 10])).

ranching(2) :-
    ranchedItems([wool, RemainingTime]),
    write('Your sheep has not produced any wool yet :('), nl,
    write('It will produce some wools in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.

ranching(3) :-
    ranchedItems([susu, RemainingTime]),
    RemainingTime == 0,
    !,
    inventory([cow, CowQuantity, _, _], X),
    inventory([susu, SusuQuantity, Level, Price], X),
    player(_, _, _, _, _, _, LevelRanching, _, _, _),
    CowQuantity1 is CowQuantity * LevelRanching,
    SusuQuantity1 is SusuQuantity + CowQuantity1,
    retractall(inventory([susu, _, _, _], X)),
    assertz(inventory([susu, SusuQuantity1, Level, Price], X)),
    expRanchingReward(N),
    write('Your each cow produces '), write(LevelRanching), write(' milks..'), nl,
    write('You got '), write(CowQuantity1), write(' milks!!'), nl,
    write('You gained '), write(N), write(' ranching exp!!'), nl,
    updateExpRanching,
    updateGoldRancher,
    retractall(ranchedItems([susu, _])),
    assertz(ranchedItems([susu, 5])).

ranching(3) :-
    ranchedItems([susu, RemainingTime]),
    write('Your cow has not produced any milk yet :('), nl,
    write('It will produce some milks in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.

/* Apabila ranching berhasil, maka jumlah Exp Ranching akan terupdate */
updateExpRanching :-
    expRanchingReward(N),
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    ExpRanching1 is ExpRanching + N,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching1, ExpPlayer, GoldPlayer)),
    updateLevelRanching(ExpRanching1).

/* Apabila exp melebihi batas untuk naik level, level akan terupdate */
updateLevelRanching(Exp):-
    Exp >= 100,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelRanching \= 2,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, 2, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, write('Congratulation!! Your Ranching Level has been upgraded to level 2!!'), nl,
    write('Now, your chicken, sheep, and cow will produce 2 items...'), nl,
    write('Your current Ranching Exp : '), write(Exp), nl,
    updateExpRanchingReward.

updateLevelRanching(Exp):-
    Exp >= 200,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelRanching \= 3,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, 3, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, write('Congratulation!! Your Ranching Level has been upgraded to level 3!!'), nl,
    write('Now, your chicken, sheep, and cow will produce 3 items...'), nl,
    write('Your current Ranching Exp : '), write(Exp), nl,
    updateExpRanchingReward.

updateLevelRanching(Exp):-
    Exp >= 300,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelRanching \= 4,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, 4, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, write('Congratulation!! Your Ranching Level has been upgraded to level 4!!'), nl,
    write('Now, your chicken, sheep, and cow will produce 4 items...'), nl,
    write('Your current Ranching Exp : '), write(Exp), nl,
    updateExpRanchingReward.

updateLevelRanching(Exp):-
    Exp >= 400,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelRanching \= 5,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, 5, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, write('Congratulation!! Your Ranching Level has been upgraded to level 5!!'), nl,
    write('Now, your chicken, sheep, and cow will produce 5 items...'), nl,
    write('Your current Ranching Exp : '), write(Exp), nl,
    updateExpRanchingReward.

updateLevelRanching(_).
/* Setelah level ranching terupdate, maka Exp Ranching Reward juga bertambah */
updateExpRanchingReward :-
    expRanchingReward(N),
    N1 is N + 10,
    retractall(expRanchingReward(_)),
    assertz(expRanchingReward(N1)).

/* Jika spesialisasi fisherman, maka akan mendapatkan tambahan gold sebanyak 20 saat panen */
updateGoldRancher :-
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Job == rancher,
    GoldPlayer1 is GoldPlayer + 20,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    checkGoal,
    write('Congrats! You got 20 golds as bonus...'), nl.

updateGoldRancher.

/* Jika berganti hari, waktu hewan memproduksi hasil ternak akan berkurang */
updateRanchedItems :-
    updateRanchedItemsEgg,
    updateRanchedItemsSusu,
    updateRanchedItemsWool.

updateRanchedItemsEgg :-
    ranchedItems([egg, RemainingTimeEgg]),
    RemainingTimeEgg > 0,
    RemainingTimeEgg1 is RemainingTimeEgg - 1,
    retractall(ranchedItems([egg, _])),
    assertz(ranchedItems([egg, RemainingTimeEgg1])), !.

updateRanchedItemsEgg. 

updateRanchedItemsWool :-
    ranchedItems([wool, RemainingTimeWool]),
    RemainingTimeWool > 0,
    RemainingTimeWool1 is RemainingTimeWool - 1,
    retractall(ranchedItems([wool, _])),
    assertz(ranchedItems([wool, RemainingTimeWool1])), !.

updateRanchedItemsWool.

updateRanchedItemsSusu :-
    ranchedItems([susu, RemainingTimeSusu]),
    RemainingTimeSusu > 0,
    RemainingTimeSusu1 is RemainingTimeSusu - 1,
    retractall(ranchedItems([susu, _])),
    assertz(ranchedItems([susu, RemainingTimeSusu1])), !.

updateRanchedItemsSusu.