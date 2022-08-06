 program Game;

 uses Crt,Graph,Dos,f_mouse,mycrt,my_mouse,io,eng,hlp;
 const m=16;n=14;size=30;elem=15;

 var
 carta: array [0..m+1,0..n+1] of Byte;
 lives: array [0..m+1,0..n+1] of byte;
 bombs:array [0..m+1,0..n+1] of Byte;
 sign: array [0..m+1,0..n+1] of byte;
 puls: array [0..m+1,0..n+1] of byte;
 pla: array [1..100] of byte;
 result: array [0..m,0..n] of byte;
 wins: array [1..100] of byte;
 wines: array [1..10] of byte;
 i,j,a,b,xm,ym,x1,y1,mox,moy,xcen,ycen:integer;
 Strin:string [5];
 lev: string;
 mouseprizn,exitprizn:boolean;
 num,pl,x,y,buttons,level,oldlevel,
 maxlevel,maxlives,maxbombs,maxpuls:Byte;
 key:Char;

 function NumOpred (key:Char):Byte;
 var i,num,really: byte;
 begin
 case Ord(key) of
 77,75,80,72,13,83:Num:=1;
 115,97,122,119,27,9:Num:=2;
 107,106,109,105,32,112:Num:=3;
 54,52,50,56,48,43:Num:=4;
 else Num:=0;
 end;
 really:=0;
 for i:=1 to pl do begin
 if pla[i]=num then really:=i;
 end;
 NumOpred:=really;
 end;

 procedure cooropred (num: byte;var x,y:byte);
 var
 i,j:byte;
 find: boolean;
 begin
 find:=false;
 for i:=1 to m do begin
 for j:=1 to n do begin
  if carta [i,j]=pla[num]+elem then begin x:=i;y:=j;find:=true;end;
 end;
 end;
 if not find then begin x:=0;y:=0;end;
 end;

 procedure check_result;
 var
 i,j: byte;
 prizn: boolean;
 begin
  prizn:=true;
  for i:=1 to m do begin
  for j:=1 to n do begin
  if (result [i,j]=1) and (carta [i,j]<>1) then prizn:= false;
  end;
  end;
  if prizn then level:=level+1;
 end;

 function pla_num_opred (x,y: byte): byte;
 var i: byte;
 begin
 for i:=1 to pl do begin
 if pla[i]=carta [x,y]-elem then pla_num_opred:=i;
 end;
 end;

 procedure reading (flag,x0,y0,sign:integer);
 var
 F: Text;
 col:char;
 prom,name:string;
 x,y,i,j,co:integer;

 begin
 prom:='';
 x0:=x0+size div 2;
 y0:=y0+size div 2;

 if flag<=elem then begin
 str (flag,prom);
 name:='editor\sprites\'+prom+'.txt';
 end
 else begin
 str (flag-elem,prom);
 name:='editor\sprites\p'+prom+'.txt';
 end;

  Assign(F,name);
  reset(F);
  readln(F,x);
  readln(f,y);
  for i:=1 to y do begin
  for j:=1 to x do begin
  read (f,col);
  if not seekeof(f) then begin
  if (col>='0') and (col<='9') then co:=ord(col)-ord('0') else co:=ord(col)-87;
  if (co<>24) then begin
  case sign of
  0,1:putpixel (j+x0,i+y0,co);
  2:putpixel (size+x0-i,y0+j,co);
  3:putpixel (size+x0-j,size+y0-i,co);
  4:putpixel (i+x0,size+y0-j,co);
  end;
  end;
  end;
  end;
  end;
  Close(F);
 end;

 procedure device (pl:byte);
 var
 i,j:integer;
 prom: integer;
 begin
 for i:=1 to getmaxx+10 do begin
 for j:=1 to getmaxy+10 do begin
 if (i mod 10=0) and (j mod 10=0) then reading (14,i-size,j-size,1);
 end;
 end;

 for i:=0 to n-1 do begin
 reading (9,-size div 2,i*size,1);
 reading (9,(n+2)*size,i*size,1);
 end;
 for i:=0 to m-1 do begin
 reading (9,i*size+1,-size div 2,2);
 reading (9,i*size+1,(m-1)*size-size,2);
 end;
 reading (15,m*size,-size div 2,1);
 reading (15,m*size-size div 2+1,n*size,2);
 reading (15,-size+1,n*size-size div 2+1,3);
 reading (15,-size div 2,-size+1,4);
 prom:=550;
 for i:=1 to pl do begin
 setfillstyle (1,0);
 bar (prom+size div 2-10,(i-1)*90+20-size div 2,prom+size+size div 2-10,(i-1)*90+size div 2+20);
 reading (pla [i]+elem,prom-10,(i-1)*90-size+20,1);
 bar (prom-30,(i-1)*90+40,prom+65,(i-1)*90+90);
 bar (prom-30,(i-1)*90+40,prom+65,(i-1)*90+90);
 bar (i*110-73,460-2,i*110+30,470+2);
 frame (prom+size div 2-10,(i-1)*90+20-size div 2,prom+size+size div 2-10,(i-1)*90+size div 2+20);
 frame (prom-30,(i-1)*90+40,prom+65,(i-1)*90+90);
 frame (i*110-73,460-2,i*110+30,470+2);
 reading (10,prom-40,(i-1)*90+30,1);
 reading (11,prom-40,(i-1)*90+45,1);
 reading (12,prom-40,(i-1)*90+60,1);
 end;
 end;

 {**************************************************************************}
 procedure pulsmenu (x,y: byte;colprizn: boolean);
 var x0,y0,i,too: integer;
 begin
 x0:=540;
 y0:=(pla_num_opred (x,y)-1)*90+75;
 setcolor (0);
 for i:=1 to 30 do begin
 line (x0+i*2,y0,x0+i*2,y0+10);
 end;
 if ColPrizn and (lives [x,y]>0) then SetColor ((carta [x,y]-elem)*3-1) else SetColor (0);
 if puls [x,y]>30 then too:=30 else too:=puls [x,y];
 for i:=1 to too do begin
 if colprizn then begin
 if i<puls [x,y] div 3 then setcolor (10);
 if (i>=puls [x,y] div 3) and (i<=(puls [x,y] div 3)*2) then setcolor (14);
 if i>(puls [x,y] div 3)*2 then setcolor (12);
 end;
 line (x0+i*2,y0,x0+i*2,y0+10);
 end;
 end;


 Procedure BombsMenu (x,y:byte;colprizn:boolean);
 Var
 too,x0,y0,i: integer;
 begin
 x0:=540;
 y0:=(pla_num_opred (x,y)-1)*90+60;
 setcolor (0);
 for i:=1 to 30 do begin
 line (x0+i*2,y0,x0+i*2,y0+10);
 end;
 if ColPrizn and (lives [x,y]>0) then SetColor ((carta [x,y]-elem)*3-1) else SetColor (0);
 if bombs [x,y]>30 then too:=30 else too:=bombs [x,y];
 for i:=1 to too do begin
 if colprizn then begin
 if i<bombs [x,y] div 3 then setcolor (10);
 if (i>=bombs [x,y] div 3) and (i<=(bombs [x,y] div 3)*2) then setcolor (14);
 if i>(bombs [x,y] div 3)*2 then setcolor (12);
 end;
 line (x0+i*2,y0,x0+i*2,y0+10);
 end;
 end;

 procedure livesmenu (x,y: byte;colprizn: boolean);
 var too,x0,y0,i: integer;
 begin
 x0:=540;
 y0:=(pla_num_opred (x,y)-1)*90+45;
 setcolor (0);
 for i:=1 to 30 do begin
 line (x0+i*2,y0,x0+i*2,y0+10);
 end;
 if ColPrizn and (lives [x,y]>0) then SetColor ((carta [x,y]-elem)*3-1) else SetColor (0);
 if lives [x,y]>30 then too:=30 else too:=lives [x,y];
 for i:=1 to too do begin
 if colprizn then begin
 if i<lives [x,y] div 3 then setcolor (10);
 if (i>=lives [x,y] div 3) and (i<=(lives [x,y] div 3)*2) then setcolor (14);
 if i>(lives [x,y] div 3)*2 then setcolor (12);
 end;
 line (x0+i*2,y0,x0+i*2,y0+10);
 end;
 end;

 procedure winsmenu (num: byte;colprizn: boolean);
 var x0,y0,i: integer;
 begin
 x0:=num*110-80;
 y0:=460;
 setfillstyle (1,0);
 for i:=1 to 10 do begin
 bar (x0+i*10,y0,x0+i*10+10-3,y0+10);
 end;
 if ColPrizn then SetFillStyle (1,pla[num]*3-1) else SetFillStyle (1,0);
 for i:=1 to wins [pla[num]] do begin
 bar (x0+i*10,y0,x0+i*10+10-3,y0+10);
 end;
 end;
 {**************************************************************************}

 procedure died (xn,yn:byte;prizn:boolean);
 begin
 bombsmenu (xn,yn,false);
 pulsmenu (xn,yn,false);
 livesmenu (xn,yn,false);
 winsmenu (pla_num_opred (xn,yn),false);
 carta[xn,yn]:=0;
 sign[xn,yn]:=0;
 reading (carta [xn,yn],(xn-1)*size,(yn-1)*size,sign [xn,yn]);
 if (puls [xn,yn]<>0) or (bombs [xn,yn]<>0) or (lives [xn,yn]<>0) then
 if prizn then reading (13,(xn-1)*size,(yn-1)*size,0);
 if pla [pla_num_opred(xn,yn)]=5 then mouseprizn:=false;
 end;


 procedure change (x,y,x1,y1:byte);
 var
 rnd: byte;
 prizn: boolean;
 begin
 if (x<>x1) or (y<>y1) then begin
 rnd:=random(3);
 prizn:=false;
 if rnd=0 then begin
 if puls [x1,y1]<>0 then prizn:=true;
 puls [x1,y1]:=puls [x,y]+puls [x1,y1]; puls [x,y]:=0;
 bombs [x1,y1]:=bombs [x,y]; bombs [x,y]:=0;
 lives [x1,y1]:=lives [x,y];lives [x,y]:=0;
 end;
 if rnd=1 then begin
 if bombs [x1,y1]<>0 then prizn:=true;
 bombs [x1,y1]:=bombs [x,y]+bombs [x1,y1]; bombs [x,y]:=0;
 puls [x1,y1]:=puls [x,y]; puls [x,y]:=0;
 lives [x1,y1]:=lives [x,y];lives [x,y]:=0;
 end;
 if rnd=2 then begin
 if lives [x1,y1]<>0 then prizn:=true;
 lives [x1,y1]:=lives [x,y]+lives [x1,y1];lives [x,y]:=0;
 bombs [x1,y1]:=bombs [x,y]; bombs [x,y]:=0;
 puls [x1,y1]:=puls [x,y]; puls [x,y]:=0;
 end;
 carta [x1,y1]:=carta [x,y];carta [x,y]:=0;
 sign [x1,y1]:=sign [x,y]; sign [x,y]:=0;
 end;
 if prizn then begin
 BombsMenu (x1,y1,true);
 pulsmenu (x1,y1,true);
 livesmenu (x1,y1,true);
 end;
 end;

 procedure CartaMake (pl,level: byte);
 var
 f:text;
 i,j,co:byte;
 col:char;
 x,y,num: byte;
 name: string[10];
 begin
  str (level,name);
  name:='lev'+name+'.txt';
  Assign(F,name);
  reset(F);
  for i:=1 to n do begin
  for j:=1 to m do begin
  read (f,col);
  if not seekeof(f) then begin
  if (col>='0') and (col<='9') then co:=ord(col)-ord('0') else co:=ord(col)-87;
  carta [j,i]:=co;
  end;
  end;
  end;

  for i:=1 to n do begin
  for j:=1 to m do begin
  read (f,col);
  if not seekeof(f) then begin
  co:=ord(col)-ord('0');
  sign [j,i]:=co;
  end;
  end;
  end;

  for i:=1 to n do begin
  for j:=1 to m do begin
  read (f,col);
  if not seekeof(f) then begin
  co:=ord(col)-ord('0');
  result [j,i]:=co;
  end;
  end;
  end;
  Close(F);

  num:=0;
  while num<pl do begin
  x:=random (m-1)+1;
  y:=random (n-1)+1;
  if carta [x,y]=0 then
  begin
  num:=num+1;
  lives [x,y]:=maxlives;
  bombs [x,y]:=maxbombs;
  puls [x,y]:=maxpuls;
  sign [x,y]:=random (4)+1;
  carta [x,y]:=pla[num]+elem;
  end;
  end;
 end;

 procedure avtors(x,y:integer);
 var
 s: array [1..10] of string;
 i: byte;
 begin
 s[1]:='Авторы:';
 s[2]:='Написал программу Петр Ковалев';
 s[3]:='Рисовали спрайты Дегтев Иван и Петр Ковалев';
 s[4]:='Идея от игры "Cокобан"';
 s[5]:='Помогали Демидов Антон и Виноградов Андрей';
 hidemouse;
 setcolor (7);
 bar (x-200+4,y-200+4,x+200-4,y+200-4);
 setcolor (0);
 for i:=1 to 5 do begin
 outtextxy (x-180,y-200+i*30,s[i]);
 end;
 repeat
 until (keypressed) or (mousepressed);
 showmouse;
 end;



{****************************************************************************}

 procedure Move (x,y:byte);
 Var
 cox,coy,sig:byte;
 px,py:shortint;
 i,prx,pry:byte;

 begin
 if lives [x,y]>0 then begin
 cox:=x;coy:=y;sig:=sign [x,y];

 case Ord (key) of
 77,115,107,54:begin
 if sign [x,y]<>2 then sign [x,y]:=2 else cox:=cox+1;end; {right}
 75,97,106,52:begin
 if sign [x,y]<>4 then sign [x,y]:=4 else cox:=cox-1;end; {left}
 80,122,109,50:begin
 if sign [x,y]<>3 then sign [x,y]:=3 else coy:=coy+1;end; {down}
 72,119,105,56: begin
 if sign [x,y]<>1 then sign [x,y]:=1 else coy:=coy-1;end; {up}
 end;

 if (cox>=1) and (cox<=m) and (coy>=1) and (coy<=n)
 and ((cox<>x) or (coy<>y) or (sign [x,y]<>sig))
 then begin
 Reading (0,(x-1)*size,(y-1)*size,0);

 if (cox<>x) or (coy<>y) then begin
 case carta [cox,coy] of

 0: begin
 change (x,y,cox,coy);
 x:=cox;y:=coy;
 end;

 1: begin
 px:=0;py:=0;
 case sign [x,y] of
 1: py:=-1;
 2: px:=1;
 3: py:=1;
 4: px:=-1;
 end;

 if (carta [cox+px,coy+py]=0) or (carta [cox+px,coy+py]=3) and (cox+px<=m)
 and (cox+px>=1) and (coy+py<=n) and (coy+py>=1) then
 begin
 if (carta [cox+px,coy+py]=3) then begin
 prx:=cox+px;pry:=coy+py;
 case_steps (sign [cox+px,coy+py],px,py);
 prx:=prx+px;pry:=pry+py;
 end
 else begin prx:=cox+px;pry:=coy+py; end;
 if (carta [prx,pry]=0) and (prx>0) and (prx<=m)
 and (pry>0) and (pry<=n)  then begin
 Reading (0,(cox-1)*size,(coy-1)*size,0);
 carta [prx,pry]:=carta [cox,coy];
 reading (1,(prx-1)*size,(pry-1)*size,1);
 change (x,y,cox,coy);
 x:=cox;y:=coy;
 end;
 end;
 end;


 end;
 end;
 Reading (carta[x,y],(x-1)*size,(y-1)*size,sign [x,y]);
 end;
 end;
 end;


 procedure movement (ifmouse: boolean);
 var
 prom: byte;

 begin
 key:=getkey;
 if key<>#0 then begin
 num:=NumOpred(key);
 end;

 prom:=random (2)+1;
 if (mouseprizn) and (prom=2) then begin
 if (mousepress=1) and (ifmouse) then begin num:=pl;key:=#83;delay (100);end;
 if (mousepress=3) and (ifmouse) then begin num:=pl;key:=#13;delay (100);end;
 mousewherexy (xm,ym);
 if (xm<=1) or (xm>=getmaxx) or (ym<=1) or (ym>=getmaxy) then setmouse (xcen,ycen);
 if (xm<>x1) or (ym<>y1) then begin
 mox:=mox+(xm-x1);moy:=moy+(ym-y1);
 if mox>20 then begin key:=#77;mox:=0;end;
 if mox<-20 then begin key:=#75;mox:=0;end;
 if moy>20 then begin key:=#80;moy:=0;end;
 if moy<-20 then begin key:=#72;moy:=0;end;
 num:=pl;
 x1:=xm;y1:=ym;
 end;
 end;

 cooropred (num,x,y);
 Move (x,y);
 end;


 procedure putimg (wait,x0,y0:integer;num,sign,step:byte;px,py:shortint);
 var
 img: array [1..100,1..100] of byte;
 nx,ny: shortint;
 k,i,j: integer;
 xp,yp: integer;
 prom: string;
 begin
 xp:=x0+size div 2;
 yp:=y0+size div 2;

 for k:=1 to size do begin
 xp:=xp+px;
 yp:=yp+py;

 if k mod step=0  then begin
 for i:=1 to size do begin
 for j:=1 to size do begin
 img [i,j]:=getpixel (xp+i,yp+j);
 movement (false);
 end;
 end;

 reading (num,x0+px*k,y0+py*k,sign);
 delay (wait);

 for i:=1 to size do begin
 for j:=1 to size do begin
 putpixel (xp+i,yp+j,img [i,j]);
 movement (false);
 end;
 end;

 end;
 end;
 end;


 procedure boom (x0,y0:integer;px,py: shortint);
 begin
 putimg (0,random(10)+x0,random(10)+y0,7,random (3)+1,20,0,0);
 end;

 procedure littleboom (x0,y0:integer;px,py: shortint);
 begin
 putimg (0,x0,y0,8,case_sign (px,py),25,0,0);
 end;

 procedure bomba;
 var
 ssign,hx,hy,xn,yn:byte;
 px,py:shortint;

 begin
 cooropred (num,x,y);
 if bombs [x,y]>0 then begin
 dec (bombs [x,y]);
 bombsmenu (x,y,true);
 px:=0;py:=0;
 case sign [x,y] of
 1: py:=-1;
 2: px:=1;
 3: py:=1;
 4: px:=-1;
 end;

 xn:=x;yn:=y;
 xn:=xn+px;yn:=yn+py;
 while (xn>0) and (xn<=m) and (yn>0) and (yn<=n)
 and (carta [xn,yn]=0) or (carta [xn,yn]=3) do begin

 if (carta [xn,yn]=3) then begin
 inc(sign [xn,yn]);if sign [xn,yn]>4 then sign [xn,yn]:=sign [xn,yn]-4;
 boom ((xn-1)*size,(yn-1)*size,px,py);
 reading (0,(xn-1)*size,(yn-1)*size,0);
 reading (carta [xn,yn],(xn-1)*size,(yn-1)*size,sign [xn,yn]);
 xn:=100;yn:=100;
 end
 else begin
 ssign:=case_sign (px,py);
 putimg (0,(xn-1-px)*size,(yn-1-py)*size,6,ssign,15,px,py);
 xn:=xn+px;yn:=yn+py;
 end;
 end;

 if (xn>0) and (xn<=m) and (yn>0) and (yn<=n) then begin
 if (carta [xn,yn]>elem) or (carta [xn,yn]=2) then
 begin
 died(xn,yn,true);
 boom((xn-1)*size,(yn-1)*size,px,py);
 end;

 if carta [xn,yn]=4 then begin
 boom((xn-1)*size,(yn-1)*size,px,py);
 end;

 if (carta [xn,yn]=1) then begin
 boom((xn-1)*size,(yn-1)*size,px,py);
 xn:=xn+px;yn:=yn+py;
 Reading (0,(xn-px-1)*size,(yn-py-1)*size,0);
 while (xn>0) and (xn<=m) and (yn>0) and (yn<=n) and (carta [xn,yn]=0) do begin

 putimg (0,(xn-px-1)*size,(yn-py-1)*size,1,1,15,px,py);
 change (xn-px,yn-py,xn,yn);
 xn:=xn+px;yn:=yn+py;
 end;
 Reading (carta [xn-px,yn-py],(xn-px-1)*size,(yn-py-1)*size,sign [xn-px,yn-py]);

 end;
 end;

 end;
 end;

 procedure pul;
 var
 xn,yn:shortint;
 nx,ny,px,py:shortint;
 cox,coy:integer;
 i,ssign:byte;

 begin
 cooropred (num,x,y);
 if puls [x,y]>0 then begin
 dec(puls [x,y]);
 pulsmenu (x,y,true);
 px:=0;py:=0;
 case sign [x,y] of
 1: py:=-1;
 2: px:=1;
 3: py:=1;
 4: px:=-1;
 end;

xn:=x;yn:=y;
xn:=xn+px;yn:=yn+py;
while (xn>0) and (xn<=m) and (yn>0) and (yn<=n)
 and ((carta [xn,yn]=0) or (carta [xn,yn]=3)) do begin

 if (carta [xn,yn]=0) then begin
 ssign:=case_sign (px,py);
 putimg (0,(xn-1-px)*size,(yn-1-py)*size,5,ssign,20,px,py);
 end;

 if (carta [xn,yn]=3) and (carta [xn-px,yn-py]=3) then begin
 ssign:=case_sign (px,py);
 putimg (0,(xn-1-px)*size,(yn-1-py)*size,5,ssign,20,px,py);
 end;

 if (carta [xn,yn]=3) then
 begin
 littleboom ((xn-1)*size,(yn-1)*size,px,py);
 case_steps(sign[xn,yn],px,py);
 end;

 xn:=xn+px;yn:=yn+py;
 end;

 if (carta [xn,yn]> elem) then begin
 dec(lives [xn,yn]);
 livesmenu (xn,yn,true);
 littleboom ((xn-1)*size,(yn-1)*size,px,py);
 if lives [xn,yn]<=0 then begin
 died (xn,yn,true);
 end;
 end;

 if (xn+px>0) and (xn+px<=m) and (yn+py>0) and (yn+py<=n) then begin
 if (carta [xn+px,yn+py]>elem) and (lives [xn+px,yn+py]<=0) then
 begin
 died(xn+px,yn+py,true);
 littleboom ((xn+px-1)*size,(yn+py-1)*size,px,py);
 end;
 end;
 if (carta [xn,yn]=1)or(carta [xn,yn]=2)
 or (carta [xn,yn]=4)
 then littleboom ((xn-1)*size,(yn-1)*size,px,py);

 end;
 end;


{****************************************************************************}

 procedure hi (var pl:byte);

 var
 x,y,xm,ym: integer;
 i,j: integer;
 col: string;
 coor: array [1..100,1..2] of integer;
 bcoor: array [1..5,1..4] of integer;
 s:array [1..40] of string;
 x0,y0,zero: integer;
 prom,number,oldnumber: byte;
 pressprizn,moprizn,prizn: boolean;
 key: char;
 label vid1;
 begin

 x0:=210;y0:=120;
 x:=getmaxx div 2;y:=getmaxy div 2;
 zero:=0;

 bcoor [1,1]:=x-170; bcoor [1,2]:=y-10+80;bcoor [1,3]:=x-70; bcoor [1,4]:=y+10+80;
 bcoor [2,1]:=x-50; bcoor [2,2]:=y-20+80;bcoor [2,3]:=x+50; bcoor [2,4]:=y+20+80;
 bcoor [3,1]:=x+70; bcoor [3,2]:=y-10+80;bcoor [3,3]:=x+170; bcoor [3,4]:=y+10+80;
 bcoor [4,1]:=x-50; bcoor [4,2]:=y-10+150;bcoor [4,3]:=x+50; bcoor [4,4]:=y+10+150;


 moprizn:=false;
 s[1]:='Кем играть будем?';
 s[2]:='Выделите:';

 s[3]:='  УПРАВЛЕНИЕ:   ПУЛЯ:   РАКЕТА:   ВИД:';
 s[4]:=' '+#24;
 s[5]:=#27+' '#26+'       DELETE    ENTER';

 s[6]:=' '+#25;
 s[7]:=' I';
 s[8]:='J K'+'         p       ПРОБЕЛ';
 s[9]:=' M';

 s[10]:=' W';
 s[11]:='A S'+'       TAB        ESC';
 s[12]:=' Z';

 s[13]:='Только при NUM LOCK';
 s[14]:=' 8';
 s[15]:='4 6'+'        +          0';
 s[16]:=' 2';

 s[17]:='МЫШЬ      ЛЕВАЯ     ПРАВАЯ';


 s[20]:='Привет!';
 s[21]:='Добро пожаловать в игру DINGO !';
 s[22]:='Что смотреть будем?';
 s[24]:='Помощь';
 s[25]:='Игра';
 s[26]:='Авторы';
 s[27]:='Ничего!';

 s[30]:='Количество уровней (не более 10):';
 s[31]:='Количество жизней у игрока (не более 10):';
 s[32]:='Количество бомб у игрока (не более 20):';
 s[33]:='Количество пуль у игрока (не более 30):';

{**************************************************************************}
 for i:=1 to getmaxx div 2 do begin
 for j:=1 to getmaxy div 2 do begin
 putpixel (i,j,random (200));
 putpixel (getmaxx-i,getmaxy-j,random (200));
 putpixel (i,getmaxy-j,random (200));
 putpixel (getmaxx-i,j,random (200));
 end;
 end;

 for i:=0 to 200 do begin
 setcolor (0);
 rectangle (x-i,y-i,x+i,y+i);
 setcolor (7);
 rectangle (x-i,y-i,x+i,y+i);
 end;
{**************************************************************************}
 vid1:

 number:=2;oldnumber:=0;
 showmouse;
 setfillstyle (1,7);
 bar (x-200,y-200,x+200,y+200);
 setfillstyle (0,0);
 setcolor (0);
 outtextxy (x-length(s[20]) div 2*8,y-150,s[20]);
 outtextxy (x-length(s[21]) div 2*8,y-130,s[21]);
 outtextxy (x-length(s[22]) div 2*8,y-100,s[22]);

 for i:=1 to 4 do begin
 button_draw (bcoor [i,1],bcoor [i,2],bcoor [i,3],bcoor [i,4],false,s[23+i]);
 end;
 frame (x-200,y-200,x+200,y+200);
 showmouse;

 getkey;
 repeat
 key:=getkey;
 if mousepressed then begin
 mousewherexy (xm,ym);
 for i:=1 to 4 do begin
 if (xm>=bcoor[i,1]) and (xm<=bcoor [i,3]) and (ym>=bcoor [i,2]) and (ym<=bcoor [i,4])
 then begin
 number:=i;
 key:=#13;
 end;
 end;
 end;
 case key of
 #77: begin if number=4 then number:=3 else number:=number+1;if number>4 then number:=1;end;
 #75: begin if number=4 then number:=1 else number:=number-1;if number<1 then number:=4;end;
 #80: if (number>=1) and (number<=3) then number:=4;
 #72: if number=4 then number:=2;
 end;
 if number<>oldnumber then begin
 setcolor (7);
 rectangle (bcoor [oldnumber,1]-3,bcoor [oldnumber,2]-3,bcoor [oldnumber,3]+3,bcoor [oldnumber,4]+3);
 oldnumber:=number;
 setcolor (0);
 rectangle (bcoor [oldnumber,1]-3,bcoor [oldnumber,2]-3,bcoor [oldnumber,3]+3,bcoor [oldnumber,4]+3);
 end;

 if key=#13 then begin
 button_draw (bcoor [number,1],bcoor [number,2],bcoor [number,3],bcoor [number,4],true,s [23+number]);
 delay (500);
 button_draw (bcoor [number,1],bcoor [number,2],bcoor [number,3],bcoor [number,4],false,s [23+number]);
 if number=1 then begin hidemouse; help ('ghelp.txt'); showmouse; key:=#0;end;
 if number=3 then begin avtors (x,y); goto vid1;end;
 if number=4 then begin exitprizn:=true;exit;end;
 end;
 until (key=#13) and (number=2);

 hidemouse;

 setcolor (7);
 bar (x-200+1,y-200+1,x+200-1,y+200-1);

 setcolor (0);
 outtextxy (x-length(s[1]) div 2*8,y-190,s[1]);
 outtextxy (x-length(s[2]) div 2*8,y-170,s[2]);
 outtextxy (x0-40,y0,s[3]);

 setcolor (2);
 outtextxy (x0,y0+20,s[4]);
 outtextxy (x0,y0+30,s[5]);
 outtextxy (x0,y0+40,s[6]);

 setcolor (5);
 outtextxy (x0,y0+80,s[7]);
 outtextxy (x0,y0+90,s[8]);
 outtextxy (x0,y0+100,s[9]);

 setcolor (8);
 outtextxy (x0,y0+140,s[10]);
 outtextxy (x0,y0+150,s[11]);
 outtextxy (x0,y0+160,s[12]);

 setcolor (11);
 outtextxy (x0,y0+190,s[13]);
 outtextxy (x0,y0+200,s[14]);
 outtextxy (x0,y0+210,s[15]);
 outtextxy (x0,y0+220,s[16]);

 setcolor (14);
 if mouseprizn then outtextxy (x0,y0+260,s[17]);
 if mouseprizn then prom:=5 else prom:=4;

 for i:=1 to prom do begin
 for j:=1 to 10 do begin
 setcolor (5);
 coor [i,1]:=x-150;coor [i,2]:=y-150+i*(400 div pl-20);
 circle (coor [i,1],coor [i,2],j div 2);
 end;
 setcolor (0);
 circle (coor [i,1],coor [i,2],6);
 setfillstyle (1,0);
 bar (coor [i,1]+290-size div 2,coor [i,2]-size div 2,coor [i,1]+290+size div 2,coor [i,2]+size div 2);
 frame (coor [i,1]+290-size div 2,coor [i,2]-size div 2,coor [i,1]+290+size div 2,coor [i,2]+size div 2);
 reading (i+elem,coor [i,1]+290-size,coor [i,2]-size,0);
 end;

 showmouse;
 number:=1;oldnumber:=0;
 pressprizn:=false;
 repeat
 if mouseprizn then prom:=5 else prom:=4;
 repeat
 key:=getkey;
 if key<>#0 then begin
 case key of
 #72: begin number:=number-1; if number<1 then number:=prom;end;
 #80: begin number:=number+1; if number>prom then number:=1;end;
 ' ': pressprizn:=true;
 end;
 end;

 mousewherexy (xm,ym);
 for i:=1 to prom do begin
 if (abs(xm-coor [i,1])<=5) and (abs(ym-coor [i,2])<=5) then begin
 hidemouse;
 setcolor (10);
 circle (coor[i,1],coor[i,2],6);
 prizn:=true;
 number:=i;
 end;
 end;

 if (mousepressed) then begin
 for i:=1 to prom do begin
 if (abs(xm-coor [i,1])<=5) and (abs(ym-coor [i,2])<=5) then begin
 number:=i;
 pressprizn:=true;
 end;
 end;
 repeat;
 until not mousepressed;
 end;

 if pressprizn then begin
 pressprizn:=false;
 if pla [number]<>0 then begin
 pla[number]:=0;
 setcolor (5);
 end
 else begin
 pla [number]:=number;
 setcolor (12);
 end;
 for j:=0 to 4 do circle (coor [number,1],coor [number,2],j);
 end;

 if number<>oldnumber then begin
 setcolor (0);
 circle (coor[oldnumber,1],coor[oldnumber,2],6);
 setcolor (10);
 circle (coor[number,1],coor[number,2],6);
 oldnumber:=number;
 end;

 if not prizn then begin
 showmouse;
 end else prizn:=false;

 until key=#13;

 pl:=prom;
 prom:=0;
 for i:=1 to pl do begin
 if pla [i]<>0 then
 begin
 if pla [i]=5 then moprizn:=true;
 prom:=prom+1;
 pla [prom]:=pla [i];
 end;
 end;
 pl:=prom;
 until pl>0;

 hidemouse;
 mouseprizn:=(mouseprizn) and (moprizn);
 setfillstyle (1,7);
 bar (x-200+4,y-200+4,x+200-4,y+200-4);
 setfillstyle (1,0);
 for i:=1 to 4 do begin
 bar (x-14,y-200+i*80,x+14,y-200+i*80+20);
 frame (x-14,y-200+i*80,x+14,y-200+i*80+20);
 setcolor (0);
 outtextxy (x-(length(s[29+i]) div 2)*8,y-200+i*80-30,s[29+i]);
 if i<>1 then reading (i+8,x-5-size div 2,y-200+i*80-20-size div 2,1);
 end;

 repeat

 bar (x-13,y-200+80+1,x+13,y-200+80+19);
 input_string (x-12,y-200+80+6,3,2,col);
 val (col,maxlevel,zero);
 until (maxlevel>0) and (maxlevel<=10);

 repeat
 bar (x-13,y-200+2*80+1,x+13,y-200+2*80+19);
 input_string (x-12,y-200+2*80+6,3,2,col);
 val (col,maxlives,zero);
 until (maxlives>0) and (maxlives<=10);

 repeat
 bar (x-13,y-200+3*80+1,x+13,y-200+3*80+19);
 input_string (x-12,y-200+3*80+6,3,2,col);
 val (col,maxbombs,zero);
 until (maxbombs>0) and (maxbombs<=20);

 repeat
 bar (x-13,y-200+4*80+1,x+13,y-200+4*80+19);
 input_string (x-12,y-200+4*80+6,3,2,col);
 val (col,maxpuls,zero);
 until (maxpuls>0) and (maxpuls<=30);

 setfillstyle (1,7);
 bar (x-200+4,y-200+4,x+200-4,y+200-4);
 outtextxy (x-24,y-10,'Готовы?');
 delay (500);
 outtextxy (x-28,y+10,'Поехали!');
 delay (500);

 cleardevice;
 hidemouse;
 end;


 procedure new;
 Var
 Break:Boolean;
 x,y:byte;

 begin
 Randomize;
 a:=vga;b:=vgahi;initgraph(a,b,'');
 Break:=true; GetCBreak (Break);
 mouseprizn:=mouseinit (buttons);
 xcen:=getmaxx div 2;ycen:=getmaxy div 2;
 pl:=5;
 cleardevice; level:=0;oldlevel:=0;
 end;

 procedure show;
 var
 coords: array [1..255,1..2] of byte;
 col,i,j: byte;
 begin
 col:=0;
 setfillstyle (1,9);
 bar (0,0,getmaxx,getmaxy);
 for i:=1 to m do begin
 for j:=1 to n do begin
 if result [i,j]=1 then begin
 col:=col+1;
 coords [col,1]:=i;coords [col,2]:=j;
 end;
 reading (0,(i-1)*size,(j-1)*size,1);
 if result [i,j]<>0 then reading (result [i,j],(i-1)*size,(j-1)*size,0)
 else reading (carta [i,j],(i-1)*size,(j-1)*size,sign[i,j]);
 end;
 end;
 settextstyle (0,0,2);
 setcolor (13);
 outtextxy (80,1,'Запомните расположение!');
 settextstyle (0,0,10);
 outtextxy (530,200,'!');
 settextstyle (0,0,0);
 setcolor (0);
 outtextxy (30,450,'Нажмите любую клавишу');
 delay (1000);

 repeat
 for i:=1 to 5 do begin
 for j:=1 to col do begin
 reading (0,(coords[j,1]-1)*size,(coords [j,2]-1)*size,0);
 end;
 delay (100);
 for j:=1 to col do begin
 reading (result [coords[j,1],coords[j,2]],(coords[j,1]-1)*size,(coords[j,2]-1)*size,0);
 end;
 delay (100);
 end;
 until (keypressed) or (mousepressed);
 getkey;
 end;

 procedure winners;
 var
 x,y,i: integer;
 prom: string;
 begin
 x:=getmaxx div 2;y:=getmaxy div 2;
 cleardevice;
 for i:=1 to 400 do begin
 setcolor (random (16));
 circle (x, y,i);
 end;
 for i:=1 to 300 do begin
 setcolor (random (16));
 rectangle (x-i, y-i, x+i, y+i);
 end;

 setfillstyle (1,7);
 bar (x-200,y-200,x+200,y+200);
 frame (x-200,y-200,x+200,y+200);

 for i:=1 to pl do begin
 setfillstyle (1,0);
 bar (x-100+size div 2,y-180+(i-1)*80+size,x-100+size+size div 2,(i-1)*80+size+size);
 frame (x-100+size div 2,y-180+(i-1)*80+size,x-100+size+size div 2,(i-1)*80+size+size);
 reading (pla[i]+elem, x-100,y-180+(i-1)*80-size div 2,1);
 setcolor (0);
 str (wins [pla[i]],prom);
 case wins [pla[i]] of
 0,5..10: prom:=prom+' побед';
 1: prom:=prom+' победа';
 2..4: prom:=prom+' победы';
 end;
 outtextxy (x-100+size+30,y-180+(i-1)*80+size div 2-4,prom);
 end;
 readkey;
 end;

 procedure cartadraw;
 var i,j:byte;
 begin
 for i:=1 to m do begin
 for j:=1 to n do begin
 reading (0,(i-1)*size,(j-1)*size,0);
 reading (carta [i,j],(i-1)*size,(j-1)*size,sign [i,j]);
 if carta [i,j]>elem then begin
 BombsMenu (i,j,true);
 pulsmenu (i,j,true);
 livesmenu (i,j,true);
 end;
 end;
 end;
 for i:=1 to pl do winsmenu (i,true);
 end;

 begin
 new;
 hi (pl);
 if exitprizn then exit;

 repeat
 movement (true);
 case ord(key) of
 13,27,32,48: Bomba;
 9,83,43,112: pul;
 14: level:=level+1;
 19: begin show; cleardevice; device (pl);cartadraw;end;
 8: help ('ghelp.txt');
 24: exit;
 end;
 check_result;
 if level<>oldlevel then begin
 str (level,lev);
 if level<>1 then wins [pla[num]]:=wins [pla[num]]+1;
 if level>maxlevel then begin winners; exit;end;
 delay (1000);
 cleardevice;
 for i:=0 to m+1 do begin
  for j:=0 to n+1 do begin
   lives [i,j]:=0;
   bombs[i,j]:=0;
   sign [i,j]:=0;
   puls [i,j]:=0;
   carta [i,j]:=0;
  end;
 end;
 setcolor (15);
 lev:='Уровень '+lev;
 settextstyle (0,0,2);
 setcolor (12);
 outtextxy (getmaxx div 2-90,getmaxy div 2-10,lev);
 settextstyle (0,0,0);
 delay (1000);
 CartaMake (pl,level);
 show;
 cleardevice;
 device (pl);
 CartaDraw;
 end;

 oldlevel:=level;
 until false;

 Repeat
 until KeyPressed;

 end.
