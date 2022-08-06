unit my_mouse;

interface

var
 mousepresent: boolean;

function mouseinit (var nb:byte):boolean;
function mousepress: byte;
procedure setmouse (x,y: word);

implementation

uses
 Dos;
var
 r: registers;
 mi: pointer;

function mouseinit (var nb: byte): boolean;
begin
 if mousepresent then
 begin
  r.ax:=0;
  intr($33,r);
  if r.ax=0 then
  begin
   nb:=0;
   mouseinit:=false;
  end
  else
  begin
   nb:=r.bx;
   mouseinit:=true;
  end;
 end
 else
 begin
  nb:=0;
  mouseinit:=false;
 end;
end;

function mousepress: byte;
var
 bmask: word;
begin
 r.ax:=3;
 intr($33,r);
 bmask:=r.bx;
 if bmask and 1<>0 then mousepress:=1
 else
 begin
  if bmask and 2<>0 then mousepress:=3
  else
  begin
   if bmask and 3<>0 then mousepress:=2;
  end;
 end;
end;

procedure setmouse (x,y: word);
begin
 r.ax:=4;
 r.cx:=x;
 r.dx:=y;
 intr($33,r);
end;



begin
 getintvec($33,mi);
 if mi=nil then mousepresent:=false
 else
 if byte(mi^)=$ce then
  mousepresent:=false
 else
  mousepresent:=true;
end.