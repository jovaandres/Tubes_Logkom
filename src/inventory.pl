% Inventory sementara
:- dynamic(inventory/1).

initInventory:-
    asserta(inventory([salmon, 0, 0, 200])),
    asserta(inventory([mackeral, 0, 0, 150])),
    asserta(inventory([tuna, 0, 0, 175])),

    asserta(inventory([cornSeed, 1, 0, 50])),
    asserta(inventory([tomatoSeed, 1, 0, 50])),
    asserta(inventory([carrotSeed, 1, 0, 50])),
    asserta(inventory([potatoSeed, 1, 0, 50])),

    asserta(inventory([corn, 0, 0, 50])),
    asserta(inventory([tomato, 0, 0, 50])),
    asserta(inventory([carrot, 0, 0, 50])),
    asserta(inventory([potato, 0, 0, 50])),

    asserta(inventory([chicken, 2, 0, 500])),
    asserta(inventory([sheep, 1, 0, 1000])),
    asserta(inventory([cow, 3, 0, 1500])),

    asserta(inventory([egg, 0, 0, 100])),
    asserta(inventory([wool, 0, 0, 200])),
    asserta(inventory([susu, 0, 0, 150])).