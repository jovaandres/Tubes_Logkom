/******************** QUEST ********************/
:- dynamic(currentQuest/1).
:- dynamic(historyQuest/1).
:- dynamic(nQuest/1).
:- dynamic(expReward/1).
:- dynamic(goldReward/1).

/***** FAKTA *****/
initQuest:-
    asserta(nQuest(1)),
    asserta(expReward(10)),
    asserta(goldReward(150)),
    initializeQuest.

/***** RULES *****/
quest :-
    running(_),
    playerPosition(X, Y),
    questLoc(X, Y),
    nQuest(N),
    N == 1,
    printNewQuest,
    incNQuest,
    !.

quest :-
    running(_),
    playerPosition(X, Y),
    questLoc(X, Y),
    currentQuest(HarvestItem, Fish, Eggs),
    HarvestItem == 0,
    Fish == 0,
    Eggs == 0,
    !,
    finishedQuest,
    newQuest,
    printNewQuest,
    updateGoldExpFromQuest,
    updateQuestReward,
    incNQuest.

quest :-
    running(_),
    playerPosition(X, Y),
    questLoc(X, Y),
    printQuest.

/* Inisialisasi Quest awal, menyesuaikan job player */
initializeQuest :-
    player(Job, _, _, _, _, _, _, _, _, _),
    Job == farmer,
    !,
    assertz(currentQuest(3, 1, 1)),
    assertz(historyQuest(3, 1, 1)).

initializeQuest :-
    player(Job, _, _, _, _, _, _, _, _, _),
    Job == fisherman,
    !,
    assertz(currentQuest(1, 3, 1)),
    assertz(historyQuest(1, 3, 1)).

initializeQuest :-
    player(Job, _, _, _, _, _, _, _, _, _),
    Job == rancher,
    !,
    assertz(currentQuest(1, 1, 3)),
    assertz(historyQuest(1, 1, 3)).

incNQuest :-
    nQuest(N),
    N1 is N + 1,
    retract(nQuest(N)),
    assertz(nQuest(N1)).

/* update quest (mengurangi jumlah quest) apabila melakukan aktivitas */
updateHarvestQuest :-
    currentQuest(HarvestItem, Fish, Eggs),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    HarvestItem1 is HarvestItem - LevelFarming,
    HarvestItem1 >= 0,
    retractall(currentQuest(HarvestItem, Fish, Eggs)),
    assertz(currentQuest(HarvestItem1, Fish, Eggs)),
    !.

updateHarvestQuest :-
    currentQuest(HarvestItem, Fish, Eggs),
    retractall(currentQuest(HarvestItem, Fish, Eggs)),
    assertz(currentQuest(0, Fish, Eggs)),
    !.

updateFishQuest :-
    currentQuest(HarvestItem, Fish, Eggs),
    player(_, _, _, _, LevelFishing, _, _, _, _, _),
    Fish1 is Fish - LevelFishing,
    Fish1 >= 0,
    retractall(currentQuest(HarvestItem, Fish, Eggs)),
    assertz(currentQuest(HarvestItem, Fish1, Eggs)),
    !.

updateFishQuest :-
    currentQuest(HarvestItem, Fish, Eggs),
    retractall(currentQuest(HarvestItem, Fish, Eggs)),
    assertz(currentQuest(HarvestItem, 0, Eggs)),
    !.

updateEggsQuest :-
    currentQuest(HarvestItem, Fish, Eggs),
    player(_, _, _, _, _, _, LevelRanching, _, _, _),
    inventory([chicken, Quantity, _, _], _),
    N is Quantity * LevelRanching,
    Eggs1 is Eggs - N,
    Eggs1 >= 0,
    retractall(currentQuest(HarvestItem, Fish, Eggs)),
    assertz(currentQuest(HarvestItem, Fish, Eggs1)),
    !.

updateEggsQuest :-
    currentQuest(HarvestItem, Fish, Eggs),
    retractall(currentQuest(HarvestItem, Fish, Eggs)),
    assertz(currentQuest(HarvestItem, Fish, 0)),
    !.

/* Menampilkan Quest */
printNewQuest :-
    currentQuest(HarvestItem, Fish, Eggs),
    write('You got a new quest!!'), nl, nl,
    write('You need to collect:'), nl,
    write('- '), write(HarvestItem), write(' harvest items'), nl,
    write('- '), write(Fish), write(' fish'), nl,
    write('- '), write(Eggs), write(' eggs'), nl.

printQuest :-
    currentQuest(HarvestItem, Fish, Eggs),
    write('You have an on-going quest!!'), nl, 
    write('Finished it first..'), nl, nl,
    write('You need to collect:'), nl,
    write('- '), write(HarvestItem), write(' harvest items'), nl,
    write('- '), write(Fish), write(' fish'), nl,
    write('- '), write(Eggs), write(' eggs'), nl.

/* Menampilkan pesan apabila berhasil menyelesaikan quest */
finishedQuest :-
    historyQuest(HarvestItem, Fish, Eggs),
    write('Congratulations!!'), nl,
    write('You have already finished previous quest'), nl,
    write('You have collected '), nl,
    write('- '), write(HarvestItem), write(' harvest items'), nl,
    write('- '), write(Fish), write(' fish'), nl,
    write('- '), write(Eggs), write(' eggs'), nl, nl,
    write('Because of your hard work, you deserve '), 
    expReward(Exps), goldReward(Golds),
    write(Exps), write(' exp and '), write(Golds), write(' golds!!'), nl, nl,
    write('But....'), nl.

/* Mengupdate Gold dan Exp player apabila quest selesai */
updateGoldExpFromQuest :-
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    expReward(Exp),
    goldReward(Gold),
    ExpPlayer1 is Exp + ExpPlayer,
    GoldPlayer1 is Gold + GoldPlayer,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer1, GoldPlayer1)),
    updateLevelPlayer(ExpPlayer1).
/* Menginisiasi quest baru */
newQuest :-
    historyQuest(HarvestItem, Fish, Eggs),
    HarvestItem1 is HarvestItem + 2,
    Fish1 is Fish + 2,
    Eggs1 is Eggs + 2,
    retractall(currentQuest(_, _, _)),
    retractall(historyQuest(_, _, _)),
    assertz(currentQuest(HarvestItem1, Fish1, Eggs1)),
    assertz(historyQuest(HarvestItem1, Fish1, Eggs1)).

/* Menambahkan reward Quest yang akan didapat apabila berhasil menyelesaikan quest */
updateQuestReward :-
    expReward(Exp),
    goldReward(Gold),
    Gold1 is Gold + 100,
    Exp1 is Exp + 5,
    retractall(expReward(_)),
    retractall(goldReward(_)),
    assertz(expReward(Exp1)),
    assertz(goldReward(Gold1)).

/* Mengupdate Level Game Player */
updateLevelPlayer(Exp) :-
    Exp >= 30,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 2,
    !,
    GoldPlayer1 is GoldPlayer + 200,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 2, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 2!!'), nl,
    write('Also... You get extra 200 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(Exp) :-
    Exp >= 60,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 3,
    !,
    GoldPlayer1 is GoldPlayer + 300,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 3, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 3!!'), nl,
    write('Also... You get extra 300 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(Exp) :-
    Exp >= 90,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 4,
    !,
    GoldPlayer1 is GoldPlayer + 400,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 4, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 4!!'), nl,
    write('Also... You get extra 400 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(Exp) :-
    Exp >= 120,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 5,
    !,
    GoldPlayer1 is GoldPlayer + 500,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 5, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 5!!'), nl,
    write('Also... You get extra 500 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(Exp) :-
    Exp >= 150,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 6,
    !,
    GoldPlayer1 is GoldPlayer + 600,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 6, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 6!!'), nl,
    write('Also... You get extra 600 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(Exp) :-
    Exp >= 180,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 7,
    !,
    GoldPlayer1 is GoldPlayer + 700,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 7, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 7!!'), nl,
    write('Also... You get extra 700 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(Exp) :-
    Exp >= 210,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 8,
    !,
    GoldPlayer1 is GoldPlayer + 800,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 8, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 8!!'), nl,
    write('Also... You get extra 800 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(Exp) :-
    Exp >= 240,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 9,
    !,
    GoldPlayer1 is GoldPlayer + 900,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 9, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 9!!'), nl,
    write('Also... You get extra 900 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(Exp) :-
    Exp >= 270,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Level \= 10,
    !,
    GoldPlayer1 is GoldPlayer + 1000,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, 10, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    write('Congratulation!! Your Game Level has been upgraded to level 10!!'), nl,
    write('Also... You get extra 1000 gold for bonus'), nl,
    write('Your current Game Exp : '), write(Exp), nl.

updateLevelPlayer(_).