% BELUM SESUAIIN LOKASI
/******************** FARMING *********************/
:- dynamic(plantedItems/1).
:- dynamic(expFarmingReward/1).

/***** FAKTA *****/
% planted(PlantItem, SisaWaktuTanam, PositionX, PositionY)
plantedItems([corn, 5]).
plantedItems([tomato, 7]).
plantedItems([carrot, 10]).
plantedItems([potato, 8]).

expFarmingReward(10).

/***** RULES *****/

ranch :-
    write('Welcome to the Farm! You have:'), nl,
    inventory([cornSeed, CornSeedQty, 0, 50]),
    inventory([tomatoSeed, TomatoSeedQty, 0, 50]),
    inventory([carrotSeed, CarrotSeedQty, 0, 50),
    inventory([potatoSeed, PotatoSeedQty, 0, 50]),
    write(CornSeedQty), write(' corn seed'), nl,
    write(TomatoSeedQty), write(' tomato seed'), nl,
    write(CarrotSeedQty), write(' carrot seed'), nl,
    write(PotatoSeedQty), write(' potato seed'), nl, nl,
    write('What do you want to do?'), nl,
    read(X),
    farming(X).

/*************************** Corn **************************/

farming(cornSeed)  :-
    plantedItems([corn, RemainingTime]),
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
    updatePlantedQuest,
    updateExpFarming,
    retractall(ranchedItems([corn, _])),
    assertz(ranchedItems([corn, 5])).

farming(cornSeed) :-
    plantedItems([corn, RemainingTime]),
    write('Your corn is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.  

/*************************** Tomato **************************/

farming(tomatoSeed)  :-
    plantedItems([tomato, RemainingTime]),
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
    updatePlantedQuest,
    updateExpFarming,
    retractall(ranchedItems([tomato, _])),
    assertz(ranchedItems([tomato, 7])).

farming(tomatoSeed) :-
    plantedItems([tomato, RemainingTime]),
    write('Your tomato is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.  

/*************************** Carrot **************************/
farming(carrotSeed)  :-
    plantedItems([carrot, RemainingTime]),
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
    updatePlantedQuest,
    updateExpFarming,
    retractall(ranchedItems([carrot, _])),
    assertz(ranchedItems([carrot, 10])).

farming(carrotSeed) :-
    plantedItems([carrot, RemainingTime]),
    write('Your carrot is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl. 

/*************************** Potato **************************/
farming(potatoSeed)  :-
    plantedItems([potato, RemainingTime]),
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
    updatePlantedQuest,
    updateExpFarming,
    retractall(ranchedItems([potato, _])),
    assertz(ranchedItems([potato, 8])).

farming(potatoSeed) :-
    plantedItems([potato, RemainingTime]),
    write('Your potato is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.

/* Apabila ranching berhasil, maka jumlah Exp Ranching akan terupdate */
updateExpRanching :-
    expRanchingReward(N),
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    ExpRanching1 is ExpRanching + N,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching1, ExpPlayer, GoldPlayer)),
    updateLevelRanching(ExpRanching1).

/* Apabila farming berhasil, maka jumlah Exp Farming akan terupdate */
updateExpFarming :-
    expFarmingReward(N),
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    ExpFarming1 is ExpFarming + N,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching1, ExpPlayer, GoldPlayer)),
    updateLevelFarming(ExpFarming1).

/* Apabila exp melebihi batas untuk naik level, level akan terupdate */
updateLevelFarming(Exp):-
    Exp >= 100,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFarming \= 2,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelFarming, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, 2, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, nl, write('Congratulation!! Your Farming Level has been upgraded to level 2!!'), nl,
    write('Now, each your corn, tomato, carrot, adn potato seed will produce 2 items...'), nl,
    write('Your current Farming Exp : '), write(Exp), nl,
    updateExpFarmingReward.

updateLevelFarming(Exp):-
    Exp >= 200,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFarming \= 3,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelFarming, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, 3, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, nl, write('Congratulation!! Your Farming Level has been upgraded to level 3!!'), nl,
    write('Now, each your corn, tomato, carrot, adn potato seed will produce 3 items...'), nl,
    write('Your current Farming Exp : '), write(Exp), nl,
    updateExpFarmingReward.

updateLevelFarming(Exp):-
    Exp >= 300,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFarming \= 4,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelFarming, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, 4, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, nl, write('Congratulation!! Your Farming Level has been upgraded to level 4!!'), nl,
    write('Now, each your corn, tomato, carrot, adn potato seed will produce 4 items...'), nl,
    write('Your current Farming Exp : '), write(Exp), nl,
    updateExpFarmingReward.

updateLevelFarming(Exp):-
    Exp >= 400,
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    LevelFarming \= 5,
    !,
    retractall(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelFarming, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, 5, ExpRanching, ExpPlayer, GoldPlayer)),
    nl, nl, write('Congratulation!! Your Farming Level has been upgraded to level 5!!'), nl,
    write('Now, each your corn, tomato, carrot, adn potato seed will produce 5 items...'), nl,
    write('Your current Farming Exp : '), write(Exp), nl,
    updateExpFarmingReward.

updateLevelRanching(_).
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
    plantedItems([corn, RemainingTimeCorn]),
    RemainingTimeCorn > 0,
    RemainingTimeCorn1 is RemainingTimeCorn - 1,
    retractall(plantedItems([corn, _])),
    assertz(plantedItems([corn, RemainingTimeCorn1])).

updatePlantedItemsCorn. 

updatePlantedItemsTomato :-
    plantedItems([tomato, RemainingTimeTomato]),
    RemainingTimeTomato > 0,
    RemainingTimeTomato1 is RemainingTimeTomato - 1,
    retractall(plantedItems([tomato, _])),
    assertz(plantedItems([tomato, RemainingTimeTomato1])).

updatePlantedItemsTomato.

updatePlantedItemsCarrot :-
    plantedItems([carrot, RemainingTimeCarrot]),
    RemainingTimeCarrot > 0,
    RemainingTimeCarrot1 is RemainingTimeCarrot - 1,
    retractall(plantedItems([carrot, _])),
    assertz(plantedItems([carrot, RemainingTimeCarrot1])).

updatePlantedItemsCarrot.

updatePlantedItemsPotato :-
    plantedItems([potato, RemainingTimePotato]),
    RemainingTimePotato > 0,
    RemainingTimePotato1 is RemainingTimePotato - 1,
    retractall(plantedItems([potato, _])),
    assertz(plantedItems([potato, RemainingTimePotato1])).

updatePlantedItemsPotato.