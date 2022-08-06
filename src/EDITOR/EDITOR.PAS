uses Crt,Graph,my_crt,io,f_mouse;

 var
  F: Text;
  col,key: char;
  prizn: boolean;
  a,b,oldcolor,color,xmo,ymo,oldxmo,oldymo,x0,y0,x0c,y0c,oldpro,pro,xin,yin: integer;
  coxmo,coymo,oldcoxmo,oldcoymo,size,prob,pos,oldpos,x,y:byte;
  prom,name: string;
  fs: text;
  image: array [1..100,1..100] of byte;

 procedure case_coords (text:string; var x1,y1,x2,y2:integer);
  begin
  if text='X' then begin x1:=625;y1:=5;x2:=635;y2:=15;end;
  if text='Сохранить' then begin x1:=520;y1:=50;x2:=620;y2:=80;end;
  if text='Сохранить как' then begin x1:=510;y1:=100;x2:=630;y2:=130;end;
  if text='Новый' then begin x1:=520;y1:=180;x2:=620;y2:=210;end;
  if text='Помощь' then begin x1:=520;y1:=260;x2:=620;y2:=290;end;
  if text='Открыть' then begin x1:=520;y1:=310;x2:=620;y2:=340;end;
  if text='+' then begin x1:=510;y1:=410;x2:=630;y2:=440;end;
  if text='-' then begin x1:=510;y1:=440;x2:=630;y2:=470;end;
  end;

  procedure clear;
  begin
  setfillstyle (1,0);
  bar (510,345,630,380);
  frame (510,345,630,380);
  setcolor (15);
  end;

 procedure help (name: string);
 const m=300;n=200;

 type
 massiv = array [0..m,0..n] of byte;
 pmas = ^massiv;

 const
 p: pmas = nil;
 max=20;

 var
 i,j: integer;
 f: text;
 s: array [1..max] of string[37];
 oldfrom,from,otst,nu: byte;
 key: char;

 begin
 otst:=3;from:=0;
 if p = nil then new (p);

if p<> nil then
begin
 for i:=0 to m do begin
  for j:=0 to n do begin
   p^ [i,j]:=getpixel (getmaxx div 2-m div 2+i,getmaxy div 2-n div 2+j);
   putpixel (getmaxx div 2-m div 2+i,getmaxy div 2-n div 2+j,0);
  end;
 end;

 repeat
 assign (f,name);
 reset (f);

 for i:=1 to from do
 begin
  readln (f,s[1]);
 end;

 nu:=0;
 for i:=1 to max do
 begin
 if not eof (f) then
 begin
  inc(nu);
  readln (f,s[nu]);
 end;
 end;

 close (f);

  setfillstyle (1,0);
  bar (getmaxx div 2-m div 2+2,getmaxy div 2-n div 2+2,getmaxx div 2+m div 2-2,getmaxy div 2+n div 2-2);
  frame (getmaxx div 2-m div 2+1,getmaxy div 2-n div 2+1,getmaxx div 2+m div 2-1,getmaxy div 2+n div 2-1);

  for i:=1 to max do
  begin
   setcolor (15);
   outtextxy (getmaxx div 2-m div 2+otst,getmaxy div 2-n div 2+(i-1)*10+otst,s[i]);
  end;

  repeat
  key:=readkey;
  oldfrom:=from;
  case ord (key) of
   80: if nu=max then inc (from);
   72: if from<>0 then dec (from);
  end;
  until (oldfrom<>from) or (key=#27);

 until key=#27;

for i:=0 to m do begin
 for j:=0 to n do begin
  putpixel (getmaxx div 2-m div 2+i,getmaxy div 2-n div 2+j,p^ [i,j]);
 end;
end;
dispose (p);
p:=nil;
end;
end;

 procedure button_draw (press:boolean;text:string);
  var x1,y1,x2,y2: integer;
  begin
  case_coords (text,x1,y1,x2,y2);
  setfillstyle (1,7);
  bar (x1,y1,x2,y2);
  setcolor (0);
  outtextxy(round(x1+(x2-x1)/2-length(text)*4+1),round(y1+(y2-y1)/2)-3,text);
  setcolor (8);
  rectangle (x1,y1,x2,y2);
  if not press then begin
  setcolor (15);
  line (x2,y1,x2,y2);
  line (x1,y1,x1,y2);
  end;
  end;

 procedure new_arr (x,y:byte);
 var i,j:byte;
 begin
  for i:=1 to y do begin
   for j:=1 to x do begin
    image [i,j]:=24;
   end;
  end;
end;

procedure newcolor (oldcol,col:byte);
 var x,y,x1,y1:integer;
 begin
 x:=420;y:=420;x1:=460;y1:=460;
 if col<>24 then begin
 if oldcolor=24 then begin
 setcolor (0);
 rectangle (x0c-prob,y0c-prob,x0c+size+prob,y0c+size+prob);
 end
 else begin
 setcolor (0);
 rectangle (oldcolor*size+prob+60-2,430-2,(oldcolor+1)*size+60+2,430+size-prob+2);
 end;
 setcolor (15);
 rectangle (color*size+prob+60-2,430-2,(color+1)*size+60+2,430+size-prob+2);
 setfillstyle (1,col);
 bar (x,y,x1,y1);
 frame (x,y,x1,y1);
 end
 else begin
 setcolor (0);
 rectangle (oldcolor*size+prob+60-2,430-2,(oldcolor+1)*size+60+2,430+size-prob+2);
 setcolor (15);
 rectangle (x0c-prob,y0c-prob,x0c+size+prob,y0c+size+prob);
 setfillstyle (1,15);
 bar (x,y,x1,y1);
 setcolor (0);
 line (x,y,x1,y1);
 line (x,y1,x1,y);
 frame (x,y,x1,y1);
 end;
 end;

 procedure input_name (x,y:integer;var name: string);
 begin
  outtextxy (520,350,' Введите имя');
  outtextxy (520,360,'   файла:');
  input_string (x,y,13,255,name);
  clear;
 end;

 procedure reading;
 var co,i,j:byte;
 str:string;
 begin

  Assign(F, name);
  {$I-}
  if name<>'' then Reset(F);
  {$I+}
  if (IOResult<>0) or (name='') then
  repeat
  clear;
  input_name (xin,yin,name);
  Assign(F, name);
  {$I-}
  if name<>'' then Reset(F);
  {$I+}
  until (IOresult=0) and (name<>'');

  readln(F,x);
  readln(f,y);
  for i:=1 to y do begin
  for j:=1 to x do begin
  read (f,col);
  if not seekeof(f) then begin
  case col of
  '0'..'9': co:=ord(col)-ord('0');
  'a'..'z': co:=ord(col)-87;
  end;
  image [i,j]:=co;
  end;
  end;
  end;
  i:=0;
  while ((x*(i+1)<450) and (y*(i+1)<350)) do i:=i+1;
  pro:=i;
  Close(F);
  setfillstyle (1,8);
  bar (0,0,getmaxx-180,10);
  str:='Путь:  ';
  str:=concat(str,copy(name,length(name)-40,40));
  setcolor (0);
  outtextxy (30,3,str);
 end;

 procedure drawone (x,y:integer);
 var co:byte;
 begin
  co:=image [x,y];
  if co<>24 then begin
  setfillstyle (1,co);
  bar ((y-1)*pro+x0,(x-1)*pro+y0,y*pro+x0,x*pro+y0);
  end
  else begin
  if pro>3 then setcolor (0) else setcolor (15);
  setfillstyle (1,15);
  bar ((y-1)*pro+x0,(x-1)*pro+y0,y*pro+x0,x*pro+y0);
  line ((y-1)*pro+x0,(x-1)*pro+y0,y*pro+x0,x*pro+y0);
  line (y*pro+x0,(x-1)*pro+y0,(y-1)*pro+x0,x*pro+y0);
  end;
  if pro>1 then begin
  setcolor (0);
  rectangle ((y-1)*pro+x0,(x-1)*pro+y0,y*pro+x0,x*pro+y0);
  end;
  end;
 procedure draw;
 var i,j:byte;
 begin
  if prizn then begin
  for i:=1 to y do begin
  for j:=1 to x do begin
  drawone (i,j);
  end;
  end;
  end
  else begin
  setfillstyle (1,15);
  bar (x0,y0,x*pro+x0,y*pro+y0);
  end;
 end;

 procedure colors;
 var i:byte;
 begin
  x0c:=60;y0c:=430;
  prob:=4;size:=10+prob;
  setfillstyle (1,0);
  bar (x0c,y0c-prob,x0c+size*16+prob,y0c+size);
  frame (x0c,y0c-prob,x0c+size*16+prob,y0c+size);
  for i:=1 to 16 do begin
  setfillstyle (1,i-1);
  bar (x0c+(i-1)*size+prob,y0c,x0c+(i)*size,y0c+size-prob);
  setcolor (15);
  rectangle (x0c+(i-1)*size+prob,y0c,x0c+(i)*size,y0c+size-prob);
  end;
  x0c:=160;y0c:=455;
  setfillstyle (1,0);
  bar (x0c-prob,y0c-prob,x0c+size+prob,y0c+size+prob);
  frame (x0c-prob-2,y0c-prob-2,x0c+size+prob+2,y0c+size+prob+2);
  setcolor (0);
  setfillstyle (1,15);
  bar (x0c,y0c,x0c+size,y0c+size);
  line (x0c,y0c,x0c+size,y0c+size);
  line (x0c,y0c+size,x0c+size,y0c);
 end;

 procedure waiting (mouse_or_keyb:boolean;text:string);
   var key:char;
   begin
   hidemouse;
        button_draw (true,text);
         delay (100);
         if mouse_or_keyb then
         repeat until not mousepressed else begin
         repeat
         until getkey<>'';
         end;
         button_draw (false,text);
    end;

  procedure mouse;
  begin
   coxmo:=round ((ymo-y0)/pro);
   coymo:=round ((xmo-x0)/pro);
   if coxmo=0 then coxmo:=1;
   if coymo=0 then coymo:=1;
   if oldcoxmo=0 then oldcoxmo:=coxmo;
   if oldcoymo=0 then oldcoymo:=coymo;
   if (oldcoxmo<>coxmo) or (oldcoymo<>coymo) or mousepressed then begin
   if mousepressed then begin
   image [coxmo,coymo]:=color;
   drawone (coxmo,coymo);
   end;
   setcolor (0);
   rectangle ((oldcoymo-1)*pro+y0,(oldcoxmo-1)*pro+x0,oldcoymo*pro+y0,oldcoxmo*pro+x0);
   setcolor (15);
   rectangle ((coymo-1)*pro+y0,(coxmo-1)*pro+x0,coymo*pro+y0,coxmo*pro+x0);
   end;
   oldcoxmo:=coxmo;oldcoymo:=coymo;
  end;

procedure buttons_make;
 begin
  button_draw (false,'Открыть');
  button_draw (false,'Сохранить');
  button_draw (false,'Сохранить как');
  button_draw (false,'Новый');
  button_draw (false,'Помощь');
  button_draw (false,'X');
  button_draw (false,'+');
  button_draw (false,'-');
 end;

procedure install;
 begin
   initgraph (a,b,'');detectgraph(a,b);
   setfillstyle (1,8);
   bar (0,0,getmaxx,getmaxy);
   clear;
   pro:=1;oldpro:=pro-1;
   x0:=20;y0:=20;
   xin:=520;yin:=370;
   new_arr (100,100);
   setfillstyle (1,15);
   bar (x0-5,y0-5,500,400);
   frame (x0-5,y0-5,500,400);
   showmouse;
   colors;
   buttons_make;
   setcolor (15);
   outtextxy (round(500+(640-500)/2)-67,20,'Редактор спрайтов');
   setcolor (10);
   outtextxy (round(500+(640-500)/2)-25,30,'Автор:');
   outtextxy (round(500+(640-500)/2)-50,40,'Петр Ковалев');
   setcolor (12);
   outtextxy (310,438,'Текущий цвет:');
   color:=15;
 end;

procedure save (name:string;x,y:byte);
 var
 f:text;
 i,j:byte;
 prom: char;
  begin

  Assign (F, name);
  {$I-}
  if name<>'' then Rewrite(F);
  {$I+}
  if (IOResult<>0) or (name='') then
  repeat
  clear;
  input_name (xin,yin,name);
  Assign(F, name);
  {$I-}
  if name<>'' then rewrite(F);
  {$I+}
  until (IOresult=0) and (name<>'');

   writeln(F,'Удалить этот файл');
   erase (F);
   Assign (f,name);
   rewrite(F);
   writeln(F,x);
   writeln(F,y);
   for i:=1 to y do begin
    for j:=1 to x do begin
     case image [i,j] of
      0..9: prom:=chr (ord('0')+image [i,j]);
      10..100:prom:=chr (87+image [i,j]);
     end;
     write (f,prom);
    end;
    writeln (f);
   end;
   writeln (f,'0');
   Close(F);
  end;

  procedure input_name_xy (x,y:integer;var name:string;var xn,yn:byte);
  var
  sx,sy:string;
  zero:integer;
  begin
  input_name (x,y,name);
  repeat
  repeat
  outtextxy (520,350,'Размер по X:');
  outtextxy (520,360,' (не > 50)');
  input_string (x,y,13,2,sx);
  val(sx,xn,zero);
  clear;
  until (xn<=50) and (xn>0);
  repeat
  outtextxy (520,350,'Размер по Y:');
  outtextxy (520,360,' (не > 50)');
  input_string (x,y,13,2,sy);
  val(sy,yn,zero);
  clear;
  until (yn<=50) and (yn>0);
  until (xn<>1) or (yn<>1);
  end;

procedure coords (xmo,ymo:integer);
 var
 prizn:boolean;
  begin
  prizn:=true;
  if (xmo>=x0) and (xmo<=x0+pro*x) and (ymo>=y0) and (ymo<=y0+pro*y) then begin
   prizn:=false;
   if (pro<>1) then mouse;
  end;
  if (ymo>=430) and (ymo<=440) and (xmo>=60) and (xmo<=285) then begin
        prizn:=false;
        if mousepressed then begin
          setcolor (0);
          rectangle (x0c-prob,y0c-prob,x0c+size+prob,y0c+size+prob);
          if (color<>pos) then begin
           if color<>24 then begin
            setcolor (0);
            rectangle (color*size+prob+60-2,430-2,(color+1)*size+60+2,430+size-prob+2);
           end;
           color:=pos;
           if color<>24 then begin
            setcolor (15);
            rectangle (color*size+prob+60-2,430-2,(color+1)*size+60+2,430+size-prob+2);
           end;
          end;
         end;
         pos:=round ((xmo-60)/size)-1;
         setcolor (0);
         rectangle (x0c-prob+2,y0c-prob+2,x0c+size+prob-2,y0c+size+prob-2);
         if pos<>oldpos then begin
          setcolor (0);
          rectangle (oldpos*size+prob+60-1,430-1,(oldpos+1)*size+60+1,430+size-prob+1);
          setlinestyle (1,0,0);
          setcolor (15);
          rectangle (pos*size+prob+60-1,430-1,(pos+1)*size+60+1,430+size-prob+1);
          setlinestyle (0,0,0);
         end;
         oldpos:=pos;
        end;
   if (ymo>=y0c) and (ymo<=y0c+size) and (xmo>=x0c) and (xmo<=x0c+size) then begin
       prizn:=false;
       if mousepressed then begin
        if color<>24 then begin
         setcolor (15);
         rectangle (x0c-prob,y0c-prob,x0c+size+prob,y0c+size+prob);
         setcolor (0);
         rectangle (color*size+prob+60-2,430-2,(color+1)*size+60+2,430+size-prob+2);
         color:=24;
        end;
       end;
       hidemouse;
       setcolor (0);
       rectangle (oldpos*size+prob+60-1,430-1,(oldpos+1)*size+60+1,430+size-prob+1);
       setlinestyle (1,0,0);
       setcolor (15);
       rectangle (x0c-prob+2,y0c-prob+2,x0c+size+prob-2,y0c+size+prob-2);
       setlinestyle (0,0,0);
      end;

  if mousepressed then begin
  case ymo of
   50..80:begin
    case xmo of
     520..620: key:=#19;
    end;
    end;
   5..15: begin
    case xmo of
     625..635: key:=#24;
    end;
   end;
   100..130:begin
    case xmo of
     510..630: key:=#1;
    end;
   end;
   180..210:begin
    case xmo of
     520..620: key:=#14;
    end;
   end;
   260..290:begin
    case xmo of
     520..620: key:=#8;
    end;
   end;
   310..340:begin
    case xmo of
     520..620: key:=#15;
    end;
   end;
   410..440:begin
    case xmo of
     510..630: key:='+';
    end;
   end;
   440..470:begin
    case xmo of
     510..630: key:='-';
    end;
   end;
   end;
  end;
   if prizn then showmouse else hidemouse;
  end;

  procedure keys;
  begin
   case key of
   #13: exit;
   '0'..'9':
   if (ord(key)-ord('0')<=15) or (ord(key)-ord('0')=24) then color:=ord(key)-ord('0');
   'a'..'z':
   if (ord(key)-87<=15) or (ord(key)-87=24) then color:=ord(key)-87;
   '+': begin
   if ((pro+1)*x+x0<500) and ((pro+1)*y+y0<400) then begin
   if pro>0 then begin prizn:=false;draw;inc(pro);waiting (false,'+');end;end;
   end;
   '-': begin
   if pro>1 then begin prizn:=false;draw;dec(pro);waiting (false,'-');end;end;
   #15: begin
    waiting (true,'Открыть');
      input_name (xin,yin,name);
      oldcoxmo:=0;oldcoymo:=0;
      reading;
      setfillstyle (1,15);
      bar (x0,y0,500,400);
      draw;
      clear;
     end;
    #19:begin waiting (true,'Сохранить'); save (name,x,y);end;
    #1:begin
    waiting (true,'Сохранить как');
    input_name (xin,yin,name);
    clear;
    save (name,x,y);
    end;
    #14:begin
      waiting (true,'Новый');
      input_name_xy (xin,yin,name,x,y);
      new_arr (x,y);save (name,x,y);
      oldcoxmo:=0;oldcoymo:=0;
      reading;
      setfillstyle (1,15);
      bar (x0,y0,500,400);
      draw;
     end;
    #24: begin
    waiting (true,'X');
    delay(500);
    key:=#24;
    end;
    #8: begin
    waiting (true,'Помощь');
    help ('ehelp.txt');
    end;
  end;
  end;

begin
  assign (fs,'path.txt');
  reset (fs);
  while not seekeof(fs) do
  begin
   readln (fs,prom);
   name:=name+prom;
  end;
  close (fs);
  install;
  reading;
  repeat
  key:=getkey;
  mousewherexy (xmo,ymo);
  coords (xmo,ymo);
  keys;
  prizn:=true;
  if oldpro<>pro then begin draw;oldpro:=pro;end;
  oldxmo:=xmo;oldymo:=ymo;
  if color<>oldcolor then newcolor (oldcolor,color);
  oldcolor:=color;
  until key=#24;
  assign (fs,'path.txt');
  rewrite (fs);
  write (fs,name);
  close (fs);
end.