unit hlp;

interface
uses
 Graph,Crt,mycrt;

procedure help (name: string);

implementation

procedure help (name: string);
const
 m=300;n=200;
type
 massiv = array [0..m,0..n] of byte;
 pmas = ^massiv;
const
 p: pmas = nil;
 max=20;
var
 i,j: integer;
 f: text;
 s: string;
 oldfrom,from,otst,nu: byte;
 key: char;
begin
 otst:=3;from:=0;
 if p = nil then new (p);
 if p <> nil then
 begin
  for i:=0 to m do
  begin
   for j:=0 to n do
   begin
    p^ [i,j]:=getpixel (getmaxx div 2-m div 2+i,getmaxy div 2-n div 2+j);
    putpixel (getmaxx div 2-m div 2+i,getmaxy div 2-n div 2+j,0);
   end;
  end;
  repeat
   assign (f,name);
   reset (f);
   for i:=1 to from do readln (f,s);
   setfillstyle (1,0);
   bar (getmaxx div 2-m div 2+2,getmaxy div 2-n div 2+2,getmaxx div 2+m div 2-2,getmaxy div 2+n div 2-2);
   frame (getmaxx div 2-m div 2+1,getmaxy div 2-n div 2+1,getmaxx div 2+m div 2-1,getmaxy div 2+n div 2-1);
   nu:=0;
   for i:=1 to max do
   begin
    if not eof (f) then
    begin
     inc (nu);
     readln (f,s);
     setcolor (15);
     outtextxy (getmaxx div 2-m div 2+otst,getmaxy div 2-n div 2+(i-1)*10+otst,s);
    end;
   end;
   close (f);
   repeat
    key:=readkey;
    oldfrom:=from;
    case ord (key) of
     80: if nu=max then inc (from);
     72: if from<>0 then dec (from);
    end;
   until (oldfrom<>from) or (key=#27);
  until key=#27;
  for i:=0 to m do
  begin
   for j:=0 to n do
   begin
    putpixel (getmaxx div 2-m div 2+i,getmaxy div 2-n div 2+j,p^ [i,j]);
   end;
  end;
  dispose (p);
  p:=nil;
 end;
end;

end.