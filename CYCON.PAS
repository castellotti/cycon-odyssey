Program TheCyconOdyssey (input, output);
{Conceived, Constructed, and Coded by Steven M. Castellotti}
{Date first line of code written: 11/18/94}
{Date final line of code written:   /  /  }
uses WinCRT,StrTools;
type
	IMatrix125 = array [1..125] of integer;
	BMatrix125 = array [1..125] of boolean;
	CMatrix36 = array [1..36] of char;
	CMatrix12 = array [1..12] of char;
	Dirs = array [1..10] of integer;
	NumberGroups = array [1..9] of integer;
	ChFile = file of char;
	NameSets = record
            Text : CMatrix36;
            Length : Integer;
            end;
	RoomID = record
            Items : NumberGroups;
            DI : Dirs;
            end;
	PlayerDats = record
						Points, Where, ArrowsShot, LastRoom : integer;
						Name : NameSets;
						WhichItems : IMatrix125;
						WhichRoomWas : BMatrix125;
						SaveName : String[12];
						PlayedBefore : char;
						end;
	ItemID = record
						NumberOf : integer;
						WhichRooms : NumberGroups;
						end;
	Rooms = array [1..125] of RoomID;
	Items = array [1..99] of ItemID;

var {Main - Global}
	Room : Rooms;
	Item : Items;
	Player : PlayerDats;
	TempInt, dir : integer;
	TempChr : char;
	RDInt, VerbText : ChFile;
	DSInt, PDSInt : text;
	verb, Command : String;

procedure Initializer;
	var IndexA, IndexB : integer;
begin
ClrScr;
{New Player Stats}
Player.LastRoom:=1;
Player.Points:=0;
Player.Where:=1;
Player.ArrowsShot:=0;
TempChr:=' ';
Player.Name.Length:=0;
for IndexA:=1 to 36 do
	Player.Name.Text[IndexA]:=' ';
for IndexA:=1 to 9 do
	begin
	while not eoln(DSInt) do
		read (DSInt, TempChr);
	readln(DSInt);
	end; {for do}
while not eoln(DSInt) do
	begin
	Player.Name.Length:=Player.Name.Length+1;
	read(DSInt, TempChr);
	Player.Name.Text[Player.Name.Length]:=TempChr;
	end; {while do}
for IndexA:=1 to 125 do
	begin
	Player.WhichItems[IndexA]:=0;
	Player.WhichRoomWas[IndexA]:=false;
	end; {for do}
{Room Description Arrays}
dir:=0;
TempChr:=' ';
write('Initializing...');
while TempChr<>'['do
	read(RDInt, TempChr);
read(RDInt, TempChr);
read(RDInt, TempChr);
for IndexA:=1 to 125 do
	begin
	for IndexB:=1 to 10 do
   	begin
      read(RDInt, TempChr);
      Room[IndexA].DI[IndexB]:=((ord(TempChr))-48)*100;
      read(RDInt, TempChr);
      Room[IndexA].DI[IndexB]:=((((ord(TempChr))-48)*10)+(Room[IndexA].DI[IndexB]));
      read(RDInt, TempChr);
      Room[IndexA].DI[IndexB]:=(((ord(TempChr))-48)+(Room[IndexA].DI[IndexB]));
      read(RDInt, TempChr);
      end; {IndexB}
	read(RDInt, TempChr);
	end; {IndexA}
writeln(' Done.');
{Item Identification}
for IndexA:=1 to 99 do
	for IndexB:=1 to 9 do
		Item[IndexA].WhichRooms[IndexB]:=125
end; {Initializer}

procedure GameIntro;
begin
TempChr:=' ';
reset(RDInt);
while TempChr<>'`' do
	begin
	write(TempChr);
	read(RDInt, TempChr);
	end; {While Do}
writeln;
writeln
end; {GameIntro}

procedure RoomDescriber;
	var counts : integer;
begin
TempChr:=' ';
TempInt:=4;
if (Player.Where) <= (Player.LastRoom)
	then begin
	reset(RDInt);
	Player.LastRoom:=1;
	end
	else Player.LastRoom:=Player.LastRoom+1;
for counts:=Player.LastRoom to Player.Where do
	begin
	while TempChr<>'`' do
		read(RDInt, TempChr);
	read(RDInt, TempChr);
	end; {The room's data entry in CycRmDat.Dat is now located}
for counts:=1 to 6 do
	read(RDInt, TempChr);
writeln;
if (Player.WhichRoomWas[Player.Where])
	then begin
	for counts:=1 to 2 do
		begin
		while TempChr<>'"' do
			read(RDInt, TempChr);
		read(RDInt, TempChr);
		end; {for do}
	TempInt:=2;
	write('You are ');
	end {If/Then}
	else Player.WhichRoomWas[Player.Where]:=true;
while TempChr<>'"' do
	begin
	write(TempChr);
	read(RDInt, TempChr);
	end; {while do}
writeln;
writeln; {Now Direction Identifications}
for counts:=1 to TempInt do
	begin
	while TempChr<>'"' do
		read(RDInt, TempChr);
	read(RDInt, TempChr);
	end; {while do}
while TempChr<>'"' do
	begin
	write(TempChr);
	read(RDInt, TempChr);
	end; {while do}
writeln
end; {Room Describer}

procedure LoadPlayerData;
begin
if (Player.PlayedBefore<>'Y') and (Player.PlayedBefore<>'y')
	then begin
	write('Do you wish to Load a Saved Game? (Y/N) ');
	readln(Player.PlayedBefore);
   end; {If/Then I}
if (Player.PlayedBefore='N') or (Player.PlayedBefore='n')
	then begin
	writeln;
	write('Is your name ');
		for TempInt:=1 to Player.Name.Length do
			write(Player.Name.Text[TempInt]);
	write(' ? (Y/N) ');
	readln(TempChr);
	if (TempChr='N') or (TempChr='n')
		then begin
			for TempInt:=1 to 36 do
				Player.Name.Text[TempInt]:=' ';
			Player.Name.Length:=0;
			write('Please type in your name: ');
			while (TempChr<>chr(13)) and (Player.Name.Length<=36) do
				begin
				Player.Name.Length:=Player.Name.Length+1;
				read(TempChr);
				Player.Name.Text[Player.Name.Length]:=TempChr;
				end; {While Do }
			Player.Name.Text[Player.Name.Length]:=' ';
			Player.Name.Length:=Player.Name.Length-1;
		end; {If Then II}
	end {Player's Name is now chosen}
	else begin
	write('What was the name of your saved game? ');
	read(Player.SaveName);
	assign(PDSInt, Player.SaveName);
	reset(PDSInt);
	Player.Name.Length:=0;
	for TempInt:=1 to 36 do
		Player.Name.Text[TempInt]:=' ';
	TempChr:=' ';
	while TempChr<>chr(13) do
		begin
		Player.Name.Length:=Player.Name.Length+1;
		read(PDSInt, TempChr);
		Player.Name.Text[Player.Name.Length]:=TempChr;
		end; {while do}
	Player.Name.Text[Player.Name.Length]:=' ';
	Player.Name.Length:=Player.Name.Length-1;
	for TempInt:=1 to 2 do
		read(PDSInt, TempChr);
	TempInt:=(ord(TempChr)-48)*100;
	read(PDSInt, TempChr);
	TempInt:=(((ord(TempChr))-48)*10)+TempInt;
	read(PDSInt, TempChr);
	TempInt:=((ord(TempChr))-48)+TempInt;
	Player.Where:=TempInt; {Last Room Player was in is now ReLoaded}
	for TempInt:=1 to 3 do
		read(PDSInt, TempChr);
	TempInt:=(((ord(TempChr))-48)*10);
	read(PDSInt, TempChr);
	TempInt:=((ord(TempChr))-48)+TempInt;
	Player.ArrowsShot:=TempInt;
	writeln('You have shot ',Player.ArrowsShot,' arrows.');
	end; {If/Else II}
if (Player.PlayedBefore='N') or (Player.PlayedBefore='n')
	then GameIntro;
RoomDescriber;
if (Player.PlayedBefore='N') or (Player.PlayedBefore='n')
	then begin
	writeln;
	write('Press Enter to begin');
	readln(verb);
	end {If/Then III}
end; {LoadPlayerData}

procedure WritePlayersName;
begin
for TempInt:=1 to Player.Name.Length do
	write(Player.Name.Text[TempInt])
end; {WritePlayersName}

procedure SavePlayersGame;
begin
writeln('Note: Names of saved games must follow the same rules of as all DOS files');
write('What would you like to name your saved game? ');
readln(Player.SaveName);
assign(PDSInt, Player.SaveName);
rewrite(PDSInt);
TempInt:=0;
while TempInt < Player.Name.Length-1 do
	begin
	TempInt:=TempInt+1;
	write(PDSInt, Player.Name.Text[TempInt]);
	end; {Player's Name is entered on the first line of the Save Game File}
writeln(PDSInt, Player.Name.Text[TempInt]);
TempInt:=Player.Where div 100;
if TempInt=0
	then TempChr:='0'
	else TempChr:='1';
write(PDSInt, TempChr);
TempInt:=Player.Where-TempInt;
TempInt:=TempInt div 10;
if TempInt > 0
	then TempChr:=chr(TempInt+48)
	else TempChr:='0';
write(PDSInt, TempChr);
TempInt:=Player.Where mod 10;
if TempInt > 0
	then TempChr:=chr(TempInt+48)
	else TempChr:='0';
writeln(PDSInt, TempChr); {Player's Current Room is Save on second line}
if Player.ArrowsShot < 10
	then TempChr:=chr(48)
	else TempChr:=chr((Player.ArrowsShot div 10)+48);
write(PDSInt, TempChr);
if Player.ArrowsShot > 0
	then TempChr:=chr((Player.ArrowsShot mod 10)+48)
	else TempChr:=chr(48);
writeln(PDSInt, TempChr);
close(PDSInt)
end; {SavePlayersGame}

procedure Load;
begin
Initializer;
reset(RDInt);
reset(DSInt);
LoadPlayerData
end; {Load}

procedure ReadRoom;
begin
writeln;
Player.LastRoom:=Player.Where+1;
writeln('*Note: There are only 125 different rooms in the game*');
write('Which Room would you like to view the description of, ');
WritePlayersName;
write(' ? ');
readln(TempInt);
Player.Where:=TempInt;
RoomDescriber
end; {ReadRoom}

procedure Help;
begin
writeln;
writeln('No one can help you now! BAHAHAHAHAHAHAHA!');
writeln;
writeln('...but if you''re REALLY lost, just type verblist for a listing of all');
writeln('availible verbs...');
writeln
end; {Help}

procedure VerbList;
begin
writeln;
reset(VerbText);
TempChr:=' ';
while TempChr<>'`' do
	begin
	read(VerbText, TempChr);
	write(TempChr);
	end {While Do}
end; {VerbList}

procedure RoomRunner;
begin
writeln;
{TextColor(13);}
writeln('You can''t go that way!');
{TextColor(7);}
Player.LastRoom:=Player.Where;
writeln
end; {RoomRunner}

procedure RoomMover;
begin
if (Room[Player.Where].DI[Dir]>0) and (Room[Player.Where].DI[Dir]<126)
	then begin
	Player.LastRoom:=(Player.Where);
	Player.Where:=(Room[Player.Where].DI[Dir]);
	end {then}
	else RoomRunner;
{TextColor(14);}
writeln('You are in Room #',Player.Where:3);
writeln('The Last Room you were in was Room #',Player.LastRoom:3);
{TextColor(7);}
dir:=0;
RoomDescriber
end; {RoomMover}

begin {Main}
assign(RDInt, 'Cycon.Dat');
assign(DSInt, 'Door.Sys');
assign(VerbText, 'Verbs.Txt');
reset(RDInt);
reset(DSInt);
Initializer;
Player.PlayedBefore:='N';
LoadPlayerData;
while (verb<>'Quit') and (verb<>'quit') and (verb<>'exit') do
	begin
	write('>');
	readln(Command);
  verb:=FindWord(Command,1);
	if (verb='Look') or (verb='look') or (verb='L') or (verb='l')
		then begin
		Player.WhichRoomWas[Player.Where]:=false;
		Player.LastRoom:=Player.Where;
		RoomDescriber;
		end; {Look If/Then}
	if (verb='Read') or (verb='read') or (verb='R') or (verb='r')
		then ReadRoom;
	if (verb='Save') or (verb='save')
		then SavePlayersGame;
	if (verb='Load') or (verb='load')
		then Load;
	if (verb='?') or (verb='Help') or (verb='help')
		then Help;
	if (verb='VerbList') or (verb='Verblist') or (verb='verblist') or (verb='list')
		then VerbList;
  if (verb='Go') or (verb='go')
  	then verb:=FindWord(Command,2);
  if (verb='Climb') or (verb='climb')
  	then if (FindWord(Command,2)='up') or (FindWord(Command,2)='down')
			then verb:=FindWord(Command,2);
	if (verb='North') or (verb='north') or (verb='N') or (verb='n')
		then dir:=1;
	if (verb='South') or (verb='south') or (verb='S') or (verb='s')
		then dir:=2;
	if (verb='East') or (verb='east') or (verb='E') or (verb='e')
		then dir:=3;
	if (verb='West') or (verb='west') or (verb='W') or (verb='w')
		then dir:=4;
	if (verb='NorthEast') or (verb='northeast') or (verb='NE') or (verb='ne')
		then dir:=5;
	if (verb='NorthWest') or (verb='northwest') or (verb='NW') or (verb='nw')
		then dir:=6;
	if (verb='SouthEast') or (verb='southeast') or (verb='SE') or (verb='se')
		then dir:=7;
	if (verb='SouthWest') or (verb='southwest') or (verb='SW') or (verb='sw')
		then dir:=8;
	if (verb='Up') or (verb='up') or (verb='U') or (verb='u')
		then dir:=9;
	if (verb='Down') or (verb='down') or (verb='D') or (verb='d')
		then dir:=10;
	if dir <> 0
		then RoomMover;
	end; {While Do}
writeln;
writeln('Thank you for playing The Cycon Odyssey');
readln
end. {TheCyconOdyssey}