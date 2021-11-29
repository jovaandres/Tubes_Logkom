:- dynamic(listDiary/1).

initDiary:-
    asserta(listDiary([])).

/***************************** SLEEPING *****************************/

teleOptions:-
    dimension(X0, Y0),
    questLoc(X1, Y1),
    ranchLoc(X2, Y2),
    houseLoc(X3, Y3),
    marketLoc(X4, Y4),
    X5 is X0 - 1,
    Y5 is Y0 - 1,
    format("Important!!\nYou can only move at coordinates X(1-~w), and Y(1-~w)", [X5 ,Y5]), nl,
    write('Special places:\n'),
    format("Quest : ~w, ~w", [X1, Y1]), nl,
    format("Ranch : ~w, ~w", [X2, Y2]), nl,
    format("House : ~w, ~w", [X3, Y3]), nl,
    format("Market: ~w, ~w", [X4, Y4]), nl.

handleTeleport(X, Y):-
    dimension(A, B),
    \+ bound(X, Y),
    \+ tileAirLoc(X, Y),
    X >= 0, X =< A,
    Y >= 0, Y =< B,
    retractall(playerPosition(_, _)),
    asserta(playerPosition(X, Y)), !.

handleTeleport(_, _):-
    write('You chose the wrong place, your request was rejected!\n'),
    write('Less chance of meeting fairies\n'),
    teleChance(C),
    retractall(teleChance(_)),
    C1 is C + 1,
    asserta(teleChance(C1)).

sleeping :-
    running(_),
    playerPosition(A, O),
    houseLoc(A, O),
    teleChance(C),
    random(0, C, M),
    random(0, C , N),
    write('Sleeping\n'),
    sleep(0.5), 
    write('.\n'),
    sleep(0.5), 
    write('.\n'),
    sleep(0.5), 
    write('.\n'),
    (
        M =:= N -> fairyhehe, write('You meet a sleeping fairy. write down the coordinates of where you want to go, and you\'ll get there.\n'),
        teleOptions,
        write('X: '), read(X),
        write('Y: '), read(Y), nl,
        handleTeleport(X, Y),
        placeInteract;
        write('It\'s morning, you wake up with a fresher and more energetic body'), nl
    ),
    asserta(move(15)),
    handleMove, !.

sleeping :-
    running(_),
    write('Are you sure you want to sleep here? Come on! You have your own house.\n').

/***************************** WRITE DIARY *****************************/
/* jika diary lebih dari 1 kata maka wajib menggunakan ''. */

fileName(Fname) :-
    day(_X),
    number_atom(_X, _Xatom),
    atom_concat('MyDiary/Day', _Xatom, _Fname1),
    atom_concat(_Fname1, '.txt', Fname).

lastElmt([X],X) :- !.
lastElmt([_|T],X) :- lastElmt(T,X).

% jika ingin mengupdate isi diary yang sudah pernah ditulis pada hari itu, list tidak perlu diappend
updateListDiary(L, [X], Lnew) :-
    L \= [],
    lastElmt(L, Last),
    Last == X,
    Lnew = L.
% jika diary baru pertama kali ditulis pada hari itu, maka list akan diappend
updateListDiary(L, [X], Lnew) :-
    ((lastElmt(L, Last), Last \= X) ; (L == [])),
    append(L, [X], Lnew).

writeDiary :-
    running(_),
    playerPosition(A, O),
    houseLoc(A, O),
    day(X),
    fileName(_Fname),
    write('Write your diary for day '), write(X), write(:), nl,
    open(_Fname, write, Stream),
    write('> '), read(Diary),
    write(Stream, '\''),
    write(Stream, Diary),
    write(Stream, '\''),
    write(Stream, '.'),
    nl(Stream),
    close(Stream),
    listDiary(L),
    updateListDiary(L, [X], Lnew),
    retractall(listDiary(_)),
    assertz(listDiary(Lnew)), !.

writeDiary :-
    running(_),
    write('You can only write your diary in your house!\n').

/* source: https://www.tutorialspoint.com/prolog/prolog_inputs_and_outputs.htm */
process_file :-
    read(Line),
    Line \== end_of_file, % when Line is not not end of file, call process.
    process(Line).

process_file :- !. % use cut to stop backtracking
 
process(Line):- %this will print the line into the console
    write(Line),nl,
    process_file.

/***************************** Read Diary *****************************/
writeListDiary([],'') :- !.
writeListDiary([H|T], X) :-
    write('- Day '), write(H), nl,
    writeListDiary(T, X).

readDiary :-
    running(_),
    playerPosition(A, O),
    houseLoc(A, O),
    listDiary(L),
    \+ L==[],
    write('Here are the list of your entries'), nl,
    writeListDiary(L, _X), nl,
    write('Which entri do you want to read?'), nl,
    write('> '), read(D),
    number_atom(D, Datom),
    atom_concat('MyDiary/Day', Datom, _Fname1),
    atom_concat(_Fname1, '.txt', Fname),
    write('Here is your entry for day '), write(D), write(':\n'),
    see(Fname), process_file, seen, !.

readDiary :-
    running(_),
    playerPosition(A, O),
    houseLoc(A, O),
    listDiary(L),
    L == [],
    write('You haven\'t written any diaries yet'), nl, !.

readDiary :-
    running(_),
    write('You can only read your diary in your house!\n').

fairyhehe :-
    nl,
    write('ssooo++++///////+++++osoooooooooyossssoooosydddddddmmddhyyhhhyyso+ss+:::::://+::::::::::::::::::::::'), nl,
    write('ssssosooooooo+++++///////+++oooossssyssyhdhhhhhhddddddydhddddhhhhds+:::::::://::::::::::::::::::::::'), nl,
    write('ssooosooooooooooooooo+++++++++++++osyhhyysssssyyyhhhhhysyyddhhhhhhhhs/:::::://::::::::::::::::::::::'), nl,
    write('ooooosooooooooo++++++++ooooooo+++osyhysosoosssyyyyyhhysosyhddhhddddddh+::::://::::::::::::::::::::::'), nl,
    write('ooooosooooooo+ooooo++ooooooooooosyhhyyyyssssyyyyyyyyyysossydddddddddddds:::://::::::::::::::::::::::'), nl,
    write('oooooooo+++oo+ooooooooooooooooyhddhhdhhyyyhhhyyhhhhyssoossshddmdddddddddy/:://::::::::::::::::::::::'), nl,
    write('oooooooo+++oo++++oooooooooooohddddhddhhhhhyhhhhyyso+oo+osyyyddddddmddddddy/://::::::::::::::::::::::'), nl,
    write('sssoosooooooo+++++++ooooooooddmmdmmmhyyyhhdhyso+oo+os+::+yhosydddhdmdmdddmy+/+:::::::::::///::::::::'), nl,
    write('o++ooo++++++++++++oooooooooymmNdmmmhyyhddhs/o//ss/++:::::/yy+/shdyhyddddhdms++:::::::::::///::::::::'), nl,
    write('///+++++/+++++++++++++oosssmmmmmmmdhyhhds//++:oy//+:::::::/oy/:oddhyyddmddmds+:::::///:::///::::::::'), nl,
    write('////o+++/+++++++//++++++ooyNmmmmmmhhdhdh/:++/:y+/+::::::::::os::odmmydmmmmmNh+:::::///:::////:::::::'), nl,
    write('////o++o/////++++//+++++oommNmmNmmddmdmo/:+/+/s://:::::::::::oo:/ddmdmmmNmmNmo/::////////////:///:::'), nl,
    write('////++o+/:::::::/o+/+++++hNmNmmNNmddNdm+::o++//:+:::::::::::::y//dommmNmNNNNNy/::////////////:///:::'), nl,
    write('::::::://///////////++++oNNNNmNNNmmmmsm+::ooo/:+::::::::::::::/s+dsymNNNNNNNNd/://///////////////:::'), nl,
    write(':::::::::////://////////dmNNNmNNmmmNm/d/::oo/://:::::::::::::::o/dh+NmNNNNNNNm+::///////////::::/:::'), nl,
    write('::::::::::::///////////hmNNNmNNmmmNNdydssooo:::::::::::::://///://++yNNNNNNNNm+/////////////::///:::'), nl,
    write(':::::::::::://////://+yNmNNNmmmmmNNdoos/////:::::::::::/osooo+o+/:::sNNdmhNNNm/////////////:::::/:::'), nl,
    write(':::::::::::::/:://///ymmNmNmmmmmmNd+/+o+/:::::::::::::::::::::::::::yNmoysNNNd///////////////:::/:::'), nl,
    write('::::::::::::::://///smmmmNmmmmmdmdohdmmmmho:::::::::::::+osyyyo+::::dhsoomNNmm/://///////////:::/:::'), nl,
    write('::::::::::::://////+dNmmmNmmmmmdm+hoomNNmyso:::::::::::odmNNdhyhs/::mh+omNNNNmy/::///::///////////::'), nl,
    write(':::::::::::////:::/yNNmmNmmmmmmmm/+::yyddyo/:::::::::::/hhddyy//h/:/d+odNNNNmNmy//////:::///////////'), nl,
    write('::::::::::/:::::/:/mNmmNmmmmmNmmm/:::/ssso/:::::::::::::+ssyso::/::o++sNNNNNNNmms////:::::://///////'), nl,
    write('::::::::::/:::::://dNmdNmmmNNmmmm+:/::/:::::::::::::::::://+/::::::o/hNNNNNNNNmmd///::::::://///////'), nl,
    write('::/::::::////:::::/sNNmmNmNNNNNNNy::::::::::::::::::::::::::::::::+hsNNNNNNNNNmmmo///::::://////////'), nl,
    write('::::::::::::::::/:/smNmmNNNNNNNNNm+:::::::::::::/:::::::::::::::::hhmNNNNNNNNNmmmy////::///////////:'), nl,
    write('::::::::///:::::/::odNNmNNNNNNNNNNd::::::::::::::::::::::::::::::sNNNNNNNNNNNNNmmh+/////://////////:'), nl,
    write('::::/shdmmmmho:::::omNmNNNNNNNNNNNNy::::::::::::::::::::::::::::oNNNNNNNNNNNNNNmmm++:::////////////:'), nl,
    write(':::smmmmmNNmmmmy/::sNNmNNNNNNNmNNNNNy::::::::::::::::::::::::::oNNNNNNNNNNNNNNNmmms//::////////////:'), nl,
    write('::omNmmmNNNmNy+yd:/yNNNmmmNNNNmNNNNNNd+::-::://++++//::-:::::+hNNNNNNNNNNNNNNNNmmdy/::::://////////:'), nl,
    write(':/mNNNNNNNNmd/:/y/ymNmNNmmNmmmmNNNNNNNNs:::::::::::::--:-::odNNNNNNNNNNNNNNNNNNmmmh+::::://////////:'), nl,
    write(':sNNNNNNNNNmo/://+mNmmmNNNNmmmmNNNNNNNNs//:::::::::::::::/+NMNNNNNNNNNNNNNNNNNmmmmd/:::::://///////:'), nl,
    write('/dNNNNNNNms/:::/+hmmmNmNNNNNNNNNNNNNNNm+/////:::::::::////+ymNNMNNNNNNNNNNNNNNmmmdd/:::::::///////::'), nl,
    write('omNNNNNNNs::::/hdmmdNNNNNNNNNNNNNNmNNds//////////://////////odmNNNNNNNNNNNNNNNNmmhd/:::////////////:'), nl,
    write('hNNNNNNNd//++ohmmNNmdNNNNNNmNNNNNmNNmy+//////////////////////+ymNNNMMNNNNNNNNNmmmhms////////////////'), nl,
    write('mNNNNNNNy+ohmmmmmmdsohmmmmmNmNNmmNNhoy+//////////////////:://+s+hmNMMNNNNNNNNNmmmdhds///////////////'), nl,
    write('mNNNNNmyyssso+///++///osommNymhymNmo/+++//////////////:::///+////+oydmNNNNNNNNNmNmdhhho+////////////'), nl,
    write('NNNNNdssso/::::::::::/+oyhmmoosdmmy///o++///////////::::///////////://oshNNMNNNNmNNmhyyhso+/////////'), nl,
    write('NNNdsssso::::::::::::+/yoyhdyodmyo////+++/////////::::////////////:::::///oymNmNNNNNmdyosyhs+///////'), nl,
    write('NNmsssss/::::::::::::+/sosyhdmdo:/::://+/+//////:::://///////////////::::////+oshhhhddysoooshs++////'), nl,
    write('NNdyssss/:::::::::::///sosymmds/:::::::////::/:::::///:/::::::::/:::::::::::::::::::::/+o+ossyys/+/+'), nl,
    write('NNdhssss/::::::::::////sohmmhos+::::::::///::::::/://::::::::::::::::::::::::::::::::::::/+osssss/+/'), nl,
    write('NNmyssss/::::::::://///oodddhoso::::::::/+//::::/:/::::::::::::::::::::::::::::::::::::::::/+yoys+++'), nl,
    write('NNmhssss/::::::://////+++ddhdooo:::::::::///:::://:::::::/:::::::::::::::::::::::::::::::::://soss++'), nl,
    write('dhhhssss+::::::::////+++/ydyhoo+::::::::::///+///::::::::/::::::::::::::::::::::::::::::::::::osys++'), nl,
    write('ssssysyyo:::::::::://////sdhhoo+::::::::////////////:::::::::::::::::::::::::::::::::::::::::::shoo+'), nl,
    write('sssssssso::::::::::+/////yomyo+/::::::::::/+/////:::///:::::::::::::::::::::::/::::::::::::::://oooo'), nl,
    write('yssssyyyy/:::::::///////oyomso/:::://:::::/:://///:////////::::::::::::::::://:///::::::::::::::+ooo'), nl,
    write('yhyyyyyyy+:::::////:://+yoyms+::::::::::///:::://////////://///::::::::::::::://:/:::::::::::::::/oo'), nl,
    write('hyssssssso::::/+//:::/oysssy/::::::::::::/:::://////////////:::::::::::::::::::::///:::::::::::::::+'), nl,
    write('ossssssso/:::::+o+//+oss+os/::::::::::::/:::::////////////////::::::::::://////::///::::::::::::::::'), nl,
    write('ssyyyssy:::::::::/://///+/:::::::::::/://:::::::://///////////////:::////////////////:::::::::::::::'), nl,
    write('yyyyyyy+::::::::::::///:::::::::::::://:::/:::::///////////////////:::////////:///+/::::::::::::::::'), nl, nl.