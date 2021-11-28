:- dynamic(inventory/2).
/************FAKTA************/

/************RULES************/

%main commands lokasi belumm

market :- 
	running(_),
	playerPosition(X, Y),
	marketLoc(X, Y),
	write('Welcome to the market, what do you want to do?\n'),
	write('1. buy\n2. sell'), !.

market :-
	running(_),
	write('You are not in the market!'), nl.


buy :- 
	running(_),
	playerPosition(X,Y),
	marketLoc(X, Y),
	write('what do you want to buy?\n\nThese are the list of items you can buy\n'),
	write('Items: \n'), bahanbuy(8), nl,
	write('Equipments: \n'), equipbuy, nl,
	readingjenis, !.

buy :-
	running(_),
	write('You are not in the market!'), nl.

sell:- 
	playerPosition(X,Y),
	marketLoc(X, Y),
	bahansell.

sell :-
	running(_),
	write('You are not in the market!'), nl.

%operasi displaying
bahanbuy(1).	
bahanbuy(N) :- 
	N1 is N-1 ,bahanbuy(N1), beliitems(N1,X,Y),
	write(N1),write('. '),write(X),write(' ('), write(Y), write(' golds)'),nl.

equipbuy :-	createlistbuyequip(B1,B2,B3,B4),cekequips(B1,B2,B3,B4).

%ngga tau gimana cara lainnya sigh
createlistbuyequip(Equip1,Equip2,Equip3,Equip4) :- 
	player(_,_,Level_Farming,_,Level_Fishing,_,Level_Ranching,_,_,_),
	findall(Name1, equipments(_,farm,Name1,Level_Farming,1,_), Equip1),
	findall(Name2, equipments(_,fish,Name2,Level_Fishing,1,_), Equip2),
	findall(Name3, equipments(_,ranch1,Name3,Level_Ranching,1,_), Equip3),
	findall(Name4, equipments(_,ranch2,Name4,Level_Ranching,1,_), Equip4).

cekequips(E1,E2,E3,E4) :- 
	(
		E1 \= [] -> displayequips(E1,farm),
		E2 \= [] -> displayequips(E2,fish),
		E3 \= [] -> displayequips(E3,ranch1),
		E4 \= [] -> displayequips(E4,ranch2), !;
		write('')
	).

displayequips([A|_],J):- 
	player(_,_,Level_Farming,_,Level_Fishing,_,Level_Ranching,_,_,_),
	(J == farm->
		equipments(No,J,A,Level_Farming,_,Pr),
		format("~w. ~w level ~w (~w golds)\n",[No,A,Level_Farming,Pr]), !;
	J == fish->
		equipments(No,J,A,Level_Fishing,_,Pr),
		format("~w. ~w level ~w (~w golds)\n",[No,A,Level_Fishing,Pr]), !;
	J == ranch1->
		equipments(No,J,A,Level_Ranching,_,Pr),
		format("~w. ~w level ~w (~w golds)\n",[No,A,Level_Ranching,Pr]), !;
	J == ranch2 ->
		equipments(No,J,A,Level_Ranching,_,Pr),
		format("~w. ~w level ~w (~w golds)\n",[No,A,Level_Ranching,Pr])).
	
	

/************Selling Operations*************/

%display sell menu
bahansell :- 
	write('Items you have in your inventory to sell\n'),
	createlistsell(N,M),
	filterkuantity(N,M), write('what do you want to sell? (Put in the name below)\n'),
	write('>> '),
	read(Selling),
	sold(Selling).

createlistsell(Result,Results) :- 
	findall(Listbarui,inventory([Listbarui, _,_,_],sell), Result),
	findall(Kuantity,inventory([_, Kuantity,_,_],sell), Results).

filterkuantity([],[]).
filterkuantity([H1|T1],[H2|T2]):-  
	H2>0 -> format("- ~w ~w\n",[H2,H1]),
			filterkuantity(T1,T2);
	filterkuantity(T1,T2).


%operasi sell
sold(Selling) :- 
	inventory([Selling,Kuantity,0,Price],sell), Kuantity > 0 -> 
		write('How many do you want to sell?\n'),
		write('>> '),
		read(Tmb),
		(Tmb=<Kuantity,Tmb>0 ->
			Hasil is Kuantity-Tmb,
			player(A,B,C,D,E,F,G,H,I,Gold),
			Earn is (Price * Tmb) + Gold,
			retract(player(_,_,_,_,_,_,_,_,_,Gold)),
			assertz(player(A,B,C,D,E,F,G,H,I,Earn)),
			checkGoal,
			retractall(inventory([Selling,Kuantity,_,_],_)),
			assertz(inventory([Selling,Hasil,0,Price],sell)),
			format("Now you have ~w Golds (before ~w)!\nItem ~w is now ~w", [Earn,Gold,Selling,Hasil]);
			Selling == 0 -> write('exiting...'),!;
		Tmb > Kuantity ->
			format("you don't have enough ~w to sell that much!", [Selling]);
		write('invalid name, number, or quantity is 0'));
	write('You don\'t have any items to sell! Come back later when you got something for me...').


/****************Back to buying****************/

%membaca jenis item yang dibeli
readingjenis :- 
	write('Which item do you want to buy?\n'),
	write('1. item\n'),
	write('2. equipment\n'),
	write('>> '),
	read(Choice),nl,
	((Choice =:= 1) ->  write('which item do you want to buy(1-7)?\n'),
						write('>> '),
						read(Pickitem), readingquantityitem(Pickitem);
	(Choice =:= 2) ->	write('which equipment do you want to buy(1-4)?\n'),
						write('>> '),
						read(Pickequipment), readingquantityequip(Pickequipment);
	write('Wrong choice! Can only enter 1 or 2')), !.


% menilai input pengguna jika kuantitas benar dan option benar
readingquantityitem(Hitungi) :- 
	((Hitungi < 8, Hitungi > 0) ->  
		write('How many do you want to buy?\n'),
		write('>> '),
		read(Jumlah),seratusitem(R,Jumlah),

		((Jumlah > 0),  R =:= 0 ->
			beliitems(Hitungi,X,Y),
			J1 is (Jumlah * Y),
			write('Okay, buying '), write(Jumlah), write(' '), write(X),
			write(', in total is '), write(J1), write(' golds.\n'),
			checkingmoney(J1,Temp), additem(Hitungi,Jumlah,Temp);
		R =:= 1 ->
			write('You don\'t have enough space to buy all of these items in your inventory');
		write('Wrong amount of items, put in a valid one .'));

	write('not a valid choice, please enter a valid one')).


readingquantityequip(Hitunge) :- player(_,_,Lvlfarm,_,Lvlfish,_,Lvlranch,_,_,_),seratusitem(R,1),  R =:= 0 ->
								 (Hitunge == 1,
								 	equipments(Hitunge,_,Nama,Lvlfarm,Am,Cost1), Am == 1 -> write('Okay, buying '),
								 														   write(Nama), write(' Level '), write(Lvlfarm),
								 														   write(' in total '), write(Cost1), write(' gold.\n'),
								 														   checkingmoney(Cost1,Temp),addequip(Hitunge,Lvlfarm,Temp)
								 														   ;
								 Hitunge == 2,
								 	equipments(Hitunge,_,Nama,Lvlfish,Am,Cost2), Am == 1 -> write('Okay, buying '),
								 														   write(Nama), write(' Level '), write(Lvlfish),
								 														   write(' in total '), write(Cost2), write(' gold.\n'),
																						   checkingmoney(Cost2,Temp),
																						   addequip(Hitunge,Lvlfish,Temp)
								 														   ;
								 Hitunge == 3,
								 	equipments(Hitunge,_,Nama,Lvlranch,Am,Cost3), Am == 1 -> write('Okay, buying '),
								 														   write(Nama), write(' Level '), write(Lvlranch),
								 														   write(' in total '), write(Cost3), write(' gold.\n'),
																						   checkingmoney(Cost3,Temp),addequip(Hitunge,Lvlranch,Temp)
								 														   ;

								 Hitunge == 4,
								 	equipments(Hitunge,_,Nama,Lvlranch,Am,Cost4), Am == 1 -> write('Okay, buying '),
								 														   write(Nama), write(' Level '), write(Lvlranch),
								 														   write(' in total '), write(Cost4), write(' gold.\n'),
								 														   checkingmoney(Cost4,Temp),addequip(Hitunge,Lvlranch,Temp)
								 														   ;
								 write('Wrong choice, put in a valid one!'));
								 write('You don\'t have enough space in your bag! Cancelling purchase...').



%mengecek jumlah uang, untuk keduanya

checkingmoney(Totalbuy,Temp) :- 
	player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, Money)->
		((Totalbuy =< Money) -> 
				M1 is Money-Totalbuy,
				retract(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, _)),
				assertz(player(Job, Level, LevelFarming, ExpFarming, LevelFishing, ExpFishing, LevelRanching, ExpRanching, ExpPlayer, M1)),
				Temp is 1;
		Temp is 0,
		write('\nTo bad your money is not enough, come by later when you have enough money! canceling ...'),!).
	



% adding item kalau berhasil

additem(Notambahinvent,Kuantambahinvent,Bool) :- 
	(Bool == 1 ->
		beliitems(Notambahinvent,Nama,_),inventory([Nama,Kuantitas,Level,Price],Jenis),
		K2 is Kuantitas + Kuantambahinvent,
		retractall(inventory([Nama,Kuantitas,Level,Price],Jenis)),
		assertz(inventory([Nama,K2,Level,Price],Jenis)),
		write(Nama),write(' purchased successfully!');

	write('\nMoney is not reduced.')).

% adding equipment kalau berhasil

addequip(Notambahinventequip,Lvl, Bool) :-

	(Bool == 1 ->
		equipments(Notambahinventequip,_,Nama,Lvl,_,_), inventory([Nama,Kuantitas,Level,Price2],Jenis),
		K2 is Kuantitas + 1,
		retractall(inventory([Nama,Kuantitas,Level,Price2],_)),
		assertz(inventory([Nama,K2,Lvl,Price2],Jenis)),
		format("Purchase ~w Level ~w succeded",[Nama,Lvl]);

	write('\nMoney is not reduced!')).