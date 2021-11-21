:-dynamic(equipments/6).



/**************FAKTA****************/

%ranching jual di marketplace (nomor,namahewan,hargajualmarket)
beliitems(1,chicken,500).
beliitems(2,sheep,1000).
beliitems(3,cow,1500).

%farming jual di marketplace (namaitem,hargajualmarket,musim)
beliitems(4,carrotSeed,50).
beliitems(5,tomatoSeed,50).
beliitems(6,potatoSeed,50).
beliitems(7,cornSeed,50).


/*equipments jual di marketplace(id,jenis,alat,level,quantity,hargajual)*/
equipments(1,farm,shovel,1,1,0).
equipments(2,fish,fishingrod,1,1,0).
equipments(3,ranch1,milker,1,1,100).
equipments(4,ranch2,shaver,1,1,100).

equipments(1,farm,shovel,2,1,200).
equipments(2,fish,fishingrod,2,1,500).
equipments(3,ranch1,milker,2,1,200).
equipments(4,ranch2,shaver,2,1,200).

equipments(1,farm,shovel,3,1,300).
equipments(2,fish,fishingrod,3,1,700).
equipments(3,ranch1,milker,3,1,600).
equipments(4,ranch2,shaver,3,1,300).

equipments(1,farm,shovel,4,0,500).
equipments(2,fish,fishingrod,4,1,800).
equipments(3,ranch1,milker,4,1,300).
equipments(4,ranch2,shaver,4,1,400).

equipments(1,farm,shovel,5,1,700).
equipments(2,fish,fishingrod,5,1,900).
equipments(3,ranch1,milker,5,1,500).
equipments(4,ranch2,shaver,5,1,500).


%aktivitas fishing eh, mau buat musimnya juga buat ikann, 
%apapun yang fish,farming,ranching, itu bisa sell oleh pemain, ini bisa dihapus sii, ambil harga dari inventory
activity(tuna,175).
activity(salmon,200).
activity(mackeral,150).

%aktivitas farming
activity(corn,75).
activity(tomato,75).
activity(carrot,75).
activity(potato,75).

%aktivitas ranching
activity(telur,100).
activity(bulu_domba,200).
activity(susu,150).