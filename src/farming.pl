/******************** FARMING *********************/
:- dynamic(planted/4).
:- dynamic(expFarmingReward/1).

/***** FAKTA *****/
% planted(PlantItem, SisaWaktuTanam, PositionX, PositionY)
initFarming:-
    asserta(expFarmingReward(10)).

plantedItems([cornSeed, 5]).
plantedItems([tomatoSeed, 7]).
plantedItems([carrotSeed, 10]).
plantedItems([potatoSeed, 8]).
/***** RULES *****/

plant :-
    running(_),
    playerPosition(X, Y),
    diggedTile(X, Y),
    write('Welcome to the Farm! You have:'), nl,
    inventory([cornSeed, CornSeedQty, 0, 50]),
    inventory([tomatoSeed, TomatoSeedQty, 0, 50]),
    inventory([carrotSeed, CarrotSeedQty, 0, 50]),
    inventory([potatoSeed, PotatoSeedQty, 0, 50]),
    write(CornSeedQty), write(' corn seed'), nl,
    write(TomatoSeedQty), write(' tomato seed'), nl,
    write(CarrotSeedQty), write(' carrot seed'), nl,
    write(PotatoSeedQty), write(' potato seed'), nl, nl,
    write('What do you want to do?'), nl,
    read(C),
    planting(C, X, Y), !.

plant :-
    running(_),
    write('You can\'t do farm here!\n'),
    write('Maybe you should dig first!\n').

harvest :-
    running(_),
    playerPosition(X, Y),
    planted(Plant, _ , X, Y),
    harvesting(Plant, X, Y), !.

harvest :-
    running(_),
    playerPosition(X, Y),
    \+ planted(_, _ , X, Y),
    write('You don\'t have planted here!\n'), !.

/**********************    Planting    *******************/
planting(cornSeed, X, Y) :-
    plantedItems([cornSeed, HarvestTime]),
    asserta(planted(corn, HarvestTime, X, Y)),
    write('Corn has been planted\n').

planting(tomatoSeed, X, Y) :-
    plantedItems([tomatoSeed, HarvestTime]),
    asserta(planted(tomato, HarvestTime, X, Y)),
    write('Tomato has been planted\n').

planting(carrotSeed, X, Y) :-
    plantedItems([carrotSeed, HarvestTime]),
    asserta(planted(carrot, HarvestTime, X, Y)),
    write('Carrot has been planted\n').

planting(potatoSeed, X, Y) :-
    plantedItems([potatoSeed, HarvestTime]),
    asserta(planted(potato, HarvestTime, X, Y)),
    write('Potato has been planted\n').

/*************************** Corn **************************/
harvesting(corn, X, Y)  :-
    planted(corn, RemainingTime, X, Y),
    RemainingTime == 0,
    !,
    inventory([cornSeed, CornSeedQty, _, _]),
    inventory([corn, CornQty, Level, Price]),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    CornSeedQty1 is CornSeedQty * LevelFarming,
    CornQty1 is CornQty + CornSeedQty1,
    retractall(inventory([corn, _, _, _])),
    assertz(inventory([corn, CornQty1, Level, Price])),
    expFarmingReward(N),
    write('Your each corn seed produce '), write(LevelFarming), write(' corn..'), nl,
    write('You got '), write(CornSeedQty1), write(' corn!!'), nl,
    write('You gained '), write(N), write(' farming exp!!'), nl,
    updateHarvestQuest,
    updateExpFarming,
    retractall(planted(corn, RemainingTime, X, Y)), !.

harvesting(corn, X, Y) :-
    planted(corn, RemainingTime, X, Y),
    write('Your corn is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.  

/*************************** Tomato **************************/

harvesting(tomato, X, Y) :-
    planted(tomato, RemainingTime, X, Y),
    RemainingTime == 0,
    !,
    inventory([tomatoSeed, TomatoSeedQty, _, _]),
    inventory([tomato, TomatoQty, Level, Price]),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    TomatoSeedQty1 is TomatoSeedQty * LevelFarming,
    TomatoQty1 is TomatoQty + TomatoSeedQty1,
    retractall(inventory([tomato, _, _, _])),
    assertz(inventory([tomato, TomatoQty1, Level, Price])),
    expFarmingReward(N),
    write('Your each tomato seed produce '), write(LevelFarming), write(' tomato..'), nl,
    write('You got '), write(TomatoSeedQty1), write(' tomato!!'), nl,
    write('You gained '), write(N), write(' farming exp!!'), nl,
    updateHarvestQuest,
    updateExpFarming,
    retractall(planted(tomato, RemainingTime, X, Y)).

harvesting(tomato, X, Y) :-
    planted(tomato, RemainingTime, X, Y),
    write('Your tomato is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.  

/*************************** Carrot **************************/

harvesting(carrot, X, Y)  :-
    planted(carrot, RemainingTime, X, Y),
    RemainingTime == 0,
    !,
    inventory([carrotSeed, CarrotSeedQty, _, _]),
    inventory([carrot, CarrotQty, Level, Price]),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    CarrotSeedQty1 is CarrotSeedQty * LevelFarming,
    CarrotQty1 is CarrotQty + CarrotSeedQty1,
    retractall(inventory([carrot, _, _, _])),
    assertz(inventory([carrot, CarrotQty1, Level, Price])),
    expFarmingReward(N),
    write('Your each carrot seed produce '), write(LevelFarming), write(' carrot..'), nl,
    write('You got '), write(CarrotSeedQty1), write(' carrot!!'), nl,
    write('You gained '), write(N), write(' farming exp!!'), nl,
    updateHarvestQuest,
    updateExpFarming,
    retractall(planted(carrot, RemainingTime, X, Y)).

harvesting(carrot, X, Y) :-
    planted(carrot, RemainingTime, X, Y),
    write('Your carrot is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl. 

/*************************** Potato **************************/

harvesting(potato, X, Y)  :-
    planted(potato, RemainingTime, X, Y),
    RemainingTime == 0,
    !,
    inventory([potatoSeed, PotatoSeedQty, _, _]),
    inventory([potato, PotatoQty, Level, Price]),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    PotatoSeedQty1 is PotatoSeedQty * LevelFarming,
    PotatoQty1 is PotatoQty + PotatoSeedQty1,
    retractall(inventory([potato, _, _, _])),
    assertz(inventory([potato, PotatoQty1, Level, Price])),
    expFarmingReward(N),
    write('Your each potato seed produce '), write(LevelFarming), write(' potato..'), nl,
    write('You got '), write(PotatoSeedQty1), write(' potato!!'), nl,
    write('You gained '), write(N), write(' farming exp!!'), nl,
    updateHarvestQuest,
    updateExpFarming,
    retractall(planted(potato, RemainingTime, X, Y)).

harvesting(potato, X, Y) :-
    planted(potato, RemainingTime, X, Y),
    write('Your potato is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.

/* Apabila farming berhasil, maka jumlah Exp Farming akan terupdate */
updateExpFarming :-
    expFarmingReward(N),
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    ExpFarming1 is ExpFarming + N,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming1, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    updateLevelFarming(ExpFarming1).

/* Apabila exp melebihi batas untuk naik level, level akan terupdate */
updateLevelFarming(Exp):-
    Exp >= 100,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFarming \= 2,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, 2, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, nl, write('Congratulation!! Your Farming Level has been upgraded to level 2!!'), nl,
    write('Now, each your corn, tomato, carrot, adn potato seed will produce 2 items...'), nl,
    write('Your current Farming Exp : '), write(Exp), nl,
    updateExpFarmingReward.

updateLevelFarming(Exp):-
    Exp >= 200,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFarming \= 3,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, 3, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, nl, write('Congratulation!! Your Farming Level has been upgraded to level 3!!'), nl,
    write('Now, each your corn, tomato, carrot, adn potato seed will produce 3 items...'), nl,
    write('Your current Farming Exp : '), write(Exp), nl,
    updateExpFarmingReward.

updateLevelFarming(Exp):-
    Exp >= 300,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFarming \= 4,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, 4, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, nl, write('Congratulation!! Your Farming Level has been upgraded to level 4!!'), nl,
    write('Now, each your corn, tomato, carrot, adn potato seed will produce 4 items...'), nl,
    write('Your current Farming Exp : '), write(Exp), nl,
    updateExpFarmingReward.

updateLevelFarming(Exp):-
    Exp >= 400,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFarming \= 5,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, 5, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, nl, write('Congratulation!! Your Farming Level has been upgraded to level 5!!'), nl,
    write('Now, each your corn, tomato, carrot, adn potato seed will produce 5 items...'), nl,
    write('Your current Farming Exp : '), write(Exp), nl,
    updateExpFarmingReward.

updateLevelFarming(_).
/* Setelah level farming terupdate, maka Exp Farming Reward juga bertambah */
updateExpFarmingReward :-
    expFarmingReward(N),
    N1 is N + 10,
    retractall(expFarmingReward(_)),
    assertz(expFarmingReward(N1)).

/* Jika berganti hari, sisa waktu panen tanaman akan berkurang */
updatePlantedItems :-
    updatePlantedItemsCorn,
    updatePlantedItemsTomato,
    updatePlantedItemsCarrot,
    updatePlantedItemsPotato.

updatePlantedItemsCorn :-
    planted(corn, RemainingTimeCorn, X, Y),
    RemainingTimeCorn > 0,
    RemainingTimeCorn1 is RemainingTimeCorn - 1,
    retractall(planted(corn, RemainingTimeCorn, X, Y)),
    assertz(planted(corn, RemainingTimeCorn1, X, Y)), !.

updatePlantedItemsCorn. 

updatePlantedItemsTomato :-
    planted(tomato, RemainingTimeTomato, X, Y),
    RemainingTimeTomato > 0,
    RemainingTimeTomato1 is RemainingTimeTomato - 1,
    retractall(planted(tomato, RemainingTimeTomato, X, Y)),
    assertz(planted(tomato, RemainingTimeTomato1, X, Y)), !.

updatePlantedItemsTomato.

updatePlantedItemsCarrot :-
    planted(carrot, RemainingTimeCarrot, X, Y),
    RemainingTimeCarrot > 0,
    RemainingTimeCarrot1 is RemainingTimeCarrot - 1,
    retractall(planted(carrot, RemainingTimeCarrot, X, Y)),
    assertz(planted(carrot, RemainingTimeCarrot1, X, Y)), !.

updatePlantedItemsCarrot.

updatePlantedItemsPotato :-
    planted(potato, RemainingTimePotato, X, Y),
    RemainingTimePotato > 0,
    RemainingTimePotato1 is RemainingTimePotato - 1,
    retractall(planted(potato, RemainingTimePotato, X, Y)),
    assertz(planted(potato, RemainingTimePotato1, X, Y)), !.

updatePlantedItemsPotato.