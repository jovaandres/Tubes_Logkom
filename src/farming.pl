/******************** FARMING *********************/
:- dynamic(planted/4).
:- dynamic(expFarmingReward/1).

/***** FAKTA *****/
initFarming:-
    asserta(expFarmingReward(10)).
% plantedItems(seed, WaktuTanam)
plantedItems([cornSeed, 5]).
plantedItems([tomatoSeed, 7]).
plantedItems([carrotSeed, 10]).
plantedItems([potatoSeed, 8]).

/***** RULES *****/

plant :-
    running(_),
    playerPosition(X, Y),
    diggedTile(X, Y),
    \+ planted(_, _, X, Y),
    write('Welcome to the Farm! You have:'), nl,
    inventory([cornSeed, CornSeedQty, 0, 50], _),
    inventory([tomatoSeed, TomatoSeedQty, 0, 50], _),
    inventory([carrotSeed, CarrotSeedQty, 0, 50], _),
    inventory([potatoSeed, PotatoSeedQty, 0, 50], _),
    write('1. '), write(CornSeedQty), write(' corn seed'), nl,
    write('2. '), write(TomatoSeedQty), write(' tomato seed'), nl,
    write('3. '), write(CarrotSeedQty), write(' carrot seed'), nl,
    write('4. '), write(PotatoSeedQty), write(' potato seed'), nl, nl,
    write('What do you want to plant?'), nl,
    write('> '), read(C),
    planting(C, X, Y), !.

plant :-
    running(_),
    playerPosition(X, Y),
    diggedTile(X, Y),
    planted(Plant, RemainingTime, X, Y),
    write('You can\'t do farm here because you have planted '), write(Plant), write(' here before!'), nl,
    write('It will ready to harvest in '), write(RemainingTime), write(' days..'), nl, !.

plant :-
    running(_),
    write('You can\'t do farm here!\n'),
    write('Maybe you should dig first!\n'), !.

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
planting(1, X, Y) :-
    inventory([cornSeed, CornSeedQty, Level, Price], B),
    CornSeedQty > 0,
    plantedItems([cornSeed, HarvestTime]),
    asserta(planted(corn, HarvestTime, X, Y)),
    CornSeedQty1 is CornSeedQty - 1,
    retractall(inventory([cornSeed, _, _, _], _)),
    assertz(inventory([cornSeed, CornSeedQty1, Level, Price], B)),
    write('Corn has been planted\n').

planting(1, _, _) :-
    inventory([cornSeed, CornSeedQty, _, _], _),
    CornSeedQty == 0,
    write('Can\'t plant corn because you don\'t have enough seed\n').

planting(2, X, Y) :-
    inventory([tomatoSeed, TomatoSeedQty, Level, Price], B),
    TomatoSeedQty > 0,
    plantedItems([tomatoSeed, HarvestTime]),
    asserta(planted(tomato, HarvestTime, X, Y)),
    TomatoSeedQty1 is TomatoSeedQty - 1,
    retractall(inventory([tomatoSeed, _, _, _], _)),
    assertz(inventory([tomatoSeed, TomatoSeedQty1, Level, Price], B)),
    write('Tomato has been planted\n').

planting(2, _, _) :-
    inventory([tomatoSeed, TomatoSeedQty, _, _], _),
    TomatoSeedQty == 0,
    write('Can\'t plant tomato because you don\'t have enough seed\n').

planting(3, X, Y) :-
    inventory([carrotSeed, CarrotSeedQty, Level, Price], B),
    CarrotSeedQty > 0,
    plantedItems([carrotSeed, HarvestTime]),
    asserta(planted(carrot, HarvestTime, X, Y)),
    CarrotSeedQty1 is CarrotSeedQty - 1,
    retractall(inventory([carrotSeed, _, _, _], _)),
    assertz(inventory([carrotSeed, CarrotSeedQty1, Level, Price], B)),
    write('Carrot has been planted\n').

planting(3, _, _) :-
    inventory([carrotSeed, CarrotSeedQty, _, _], _),
    CarrotSeedQty == 0,
    write('Can\'t plant carrot because you don\'t have enough seed\n').

planting(4, X, Y) :-
    inventory([potatoSeed, PotatoSeedQty, Level, Price], B),
    PotatoSeedQty > 0,
    plantedItems([potatoSeed, HarvestTime]),
    asserta(planted(potato, HarvestTime, X, Y)),
    PotatoSeedQty1 is PotatoSeedQty - 1,
    retractall(inventory([potatoSeed, _, _, _], _)),
    assertz(inventory([potatoSeed, PotatoSeedQty1, Level, Price], B)),
    write('Potato has been planted\n').

planting(4, _, _) :-
    inventory([potatoSeed, PotatoSeedQty, _, _], _),
    PotatoSeedQty == 0,
    write('Can\'t plant potato because you don\'t have enough seed\n').

/*************************** Corn **************************/
harvesting(corn, X, Y)  :-
    planted(corn, RemainingTime, X, Y),
    RemainingTime == 0,
    inventory([corn, CornQty, Level, Price], S),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    CornQty1 is CornQty + LevelFarming,
    seratusitem(C,LevelFarming), C == 0, !,
    retractall(inventory([corn, _, _, _], _)),
    assertz(inventory([corn, CornQty1, Level, Price], S)),
    expFarmingReward(N),
    retract(diggedTile(X, Y)),
    gotHarvest,
    write('You got '), write(LevelFarming), write(' corn!!'), nl,
    write('You gained '), write(N), write(' farming exp!!'), nl,
    updateHarvestQuest,
    updateExpFarming,
    updateGoldFarmer,
    retractall(planted(corn, RemainingTime, X, Y)), !.

harvesting(corn, X, Y) :-
    planted(corn, RemainingTime, X, Y), RemainingTime > 0, !,
    write('Your corn is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.  

/*************************** Tomato **************************/

harvesting(tomato, X, Y) :-
    planted(tomato, RemainingTime, X, Y),
    RemainingTime == 0,
    inventory([tomato, TomatoQty, Level, Price], S),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    TomatoQty1 is TomatoQty + LevelFarming,
    seratusitem(C,LevelFarming), C == 0, !,
    retractall(inventory([tomato, _, _, _], _)),
    assertz(inventory([tomato, TomatoQty1, Level, Price], S)),
    expFarmingReward(N),
    retract(diggedTile(X, Y)),
    gotHarvest,
    write('You got '), write(LevelFarming), write(' tomato!!'), nl,
    write('You gained '), write(N), write(' farming exp!!'), nl,
    updateHarvestQuest,
    updateExpFarming,
    updateGoldFarmer,
    retractall(planted(tomato, RemainingTime, X, Y)).

harvesting(tomato, X, Y) :-
    planted(tomato, RemainingTime, X, Y), RemainingTime > 0, !,
    write('Your tomato is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.  

/*************************** Carrot **************************/

harvesting(carrot, X, Y)  :-
    planted(carrot, RemainingTime, X, Y),
    RemainingTime == 0,
    inventory([carrot, CarrotQty, Level, Price], S),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    CarrotQty1 is CarrotQty + LevelFarming,
    seratusitem(C,LevelFarming), C == 0,!,
    retractall(inventory([carrot, _, _, _], _)),
    assertz(inventory([carrot, CarrotQty1, Level, Price], S)),
    expFarmingReward(N),
    retract(diggedTile(X, Y)),
    gotHarvest,
    write('You got '), write(LevelFarming), write(' carrot!!'), nl,
    write('You gained '), write(N), write(' farming exp!!'), nl,
    updateHarvestQuest,
    updateExpFarming,
    updateGoldFarmer,
    retractall(planted(carrot, RemainingTime, X, Y)).

harvesting(carrot, X, Y) :-
    planted(carrot, RemainingTime, X, Y), RemainingTime > 0, !,
    write('Your carrot is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl. 

/*************************** Potato **************************/

harvesting(potato, X, Y)  :-
    planted(potato, RemainingTime, X, Y),
    RemainingTime == 0,
    inventory([potato, PotatoQty, Level, Price], S),
    player(_, _, LevelFarming, _, _, _, _, _, _, _),
    PotatoQty1 is PotatoQty + LevelFarming,
    seratusitem(C,LevelFarming), C == 0, !,
    retractall(inventory([potato, _, _, _], _)),
    assertz(inventory([potato, PotatoQty1, Level, Price], S)),
    expFarmingReward(N),
    retract(diggedTile(X, Y)),
    gotHarvest,
    write('You got '), write(LevelFarming), write(' potato!!'), nl,
    write('You gained '), write(N), write(' farming exp!!'), nl,
    updateHarvestQuest,
    updateExpFarming,
    updateGoldFarmer,
    retractall(planted(potato, RemainingTime, X, Y)).

harvesting(potato, X, Y) :-
    planted(potato, RemainingTime, X, Y),  RemainingTime > 0, !,
    write('Your potato is not ready to harvest yet:('), nl,
    write('It will ready in '), write(RemainingTime), write(' days..'), nl,
    write('Please check again later..'), nl.

/* Message Inventory penuh */
harvesting(_,_,_):-
    write('Oh no! I need to do something to my inventory in order to harvest these...').

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

/* Jika spesialisasi farmer, maka akan mendapatkan tambahan gold sebanyak 20 saat panen */
updateGoldFarmer :-
    player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer),
    Job == farmer,
    GoldPlayer1 is GoldPlayer + 20,
    retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer)),
    assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, GoldPlayer1)),
    checkGoal,
    write('Congrats! You got 20 golds as bonus...'), nl.

updateGoldFarmer.    

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

gotHarvest:-
    nl,
    write('                       .                      '), nl,
    write('                     .//-                     '), nl,
    write('                   `:////.                    '), nl,
    write('                  -///////                    '), nl,
    write('                `:////////-                   '), nl,
    write('                .//////////                   '), nl,
    write('                `/////////-                   '), nl,
    write('                 `-/////:.                    '), nl,
    write('         ``.--::::-./o``                      '), nl,
    write('       `:///////////+s   ``                   '), nl,
    write('        `-//////////os`-:///::--.``           '), nl,
    write('          `-/////////s///////////:`           '), nl,
    write('             .-::-.`:o/////////:.             '), nl,
    write('                   `/s://////:.               '), nl,
    write('                `:+oos++/--.`                 '), nl,
    write('               .ossssssss/                    '), nl,
    write('           `...+ssssssssss-...`               '), nl,
    write('         :+osssssssssssssssssso/`             '), nl,
    write('        /ssssssssssssssssssssssso`            '), nl,
    write('        ossssssssssssssssssssssss:            '), nl,
    write('        -::::::::::::::::::::::::`            '), nl, nl.