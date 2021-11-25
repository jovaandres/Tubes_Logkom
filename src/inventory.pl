% Inventory sementara
:- dynamic(inventory/2).

initInventory:-
    asserta(inventory([salmon, 0, 0, 200],sell)),
    asserta(inventory([mackeral, 0, 0, 150],sell)),
    asserta(inventory([tuna, 0, 0, 175],sell)),

    asserta(inventory([cornSeed, 1, 0, 50],buy)),
    asserta(inventory([tomatoSeed, 1, 0, 50],buy)),
    asserta(inventory([carrotSeed, 1, 0, 50],buy)),
    asserta(inventory([potatoSeed, 1, 0, 50],buy)),

    asserta(inventory([corn, 0, 0, 50],sell)),
    asserta(inventory([tomato, 0, 0, 50],sell)),
    asserta(inventory([carrot, 0, 0, 50],sell)),
    asserta(inventory([potato, 0, 0, 50],sell)),

    asserta(inventory([chicken, 2, 0, 500],sell)),
    asserta(inventory([sheep, 1, 0, 1000],sell)),
    asserta(inventory([cow, 3, 0, 1500],sell)),

    asserta(inventory([egg, 0, 0, 100],sell)),
    asserta(inventory([wool, 0, 0, 200],sell)),
    asserta(inventory([susu, 0, 0, 150],sell)),

    asserta(inventory([shovel,0,0,300],alat)),
    asserta(inventory([fishingrod,0,0,300],alat)),
    asserta(inventory([milker,0,0,300],alat)),
    asserta(inventory([shaver,0,0,300],alat)).

inventory:- 
    running(_),
    createliststuff(_,Y,_),sumlist(Y,N1),
    format("Your inventory (~w/100)~n",[N1]),
    displayinginv.

throwItem :-
    running(_),
    write('Your inventory:\n'),
    displayinginv,write('what do you want to throw?\n'),
    read(Buang),cekBuang(Buang).


%memfilter inventory yang lebih dari nol

displayinginv :- 
    createliststuff(N1,N2,N3),filterkuantities(N1,N2,N3).

createliststuff(Result,Results,Resultss) :- 
    findall(Listbarui,inventory([Listbarui, _,_,_],_), Result),
    findall(Kuantity,inventory([_, Kuantity,_,_],_), Results),
    findall(Level, inventory([_,_,Level,_],_),Resultss).

filterkuantities([],[],[]).
filterkuantities([H1|T1],[H2|T2],[H3|T3]):-  
    H2>0,H3 =:= 0 -> 
        format("~w ~w\n",[H2,H1]),
        filterkuantities(T1,T2,T3)
        ;
    H2>0,H3>0 -> 
        format("~w Level ~w ~w\n",[H2,H3,H1]),                                                        
        filterkuantities(T1,T2,T3)
        ;
    filterkuantities(T1,T2,T3).


sumlist([],0).
sumlist([H5|T5],N):-
    sumlist(T5,N1),
    N is N1+H5.
                    
%mengecek input
cekBuang(Buang):- 
    inventory([Buang,Jml,_,_],_),Jml>0 -> 
        format("You have ~w ~w. How many do you want to throw?",[Jml,Buang]),
        read(Count), cekCount(Buang,Count,Jml);
    write('There is no such thing!').

cekCount(Penamaan, Membuang,Jmlh):- 
    Jmlh >= Membuang -> 
        K2 is (Jmlh - Membuang),write(K2),
        retract(inventory([Penamaan,_,Lefel,Harga],Jenis)),
        assertz(inventory([Penamaan,K2,Lefel,Harga],Jenis)),
        format("You threw away ~w ~w.",[Membuang,Penamaan]);
    format("You don't have enough ~w. Cancelling...",[Penamaan]).