unit io;

interface
uses graph,crt;

 procedure input_string (x,y:integer;max,full_max:byte;var str:string);
 function getkey: char;

implementation

 procedure input_string (x,y:integer;max,full_max:byte;var str:string);
 var
 key:char;
 print_string:string;
 old_color:byte;
 begin
  max:=max-1;
  old_color:=getcolor;
  str:='';print_string:='';
  repeat
  setcolor (15);
  outtextxy (x,y,print_string);
  outtextxy (x+length(print_string)*8,y,'_');
  key:=readkey;
  setcolor (0);
  outtextxy (x,y,print_string);
  outtextxy (x+length(print_string)*8,y,'_');
  if (key>=#40) and (key<=#122) then str:=str+key;
  if key=#8 then begin
  str:=copy(str,1,length(str)-1);
  end;
  if length (str)>full_max then str:=copy(str,1,length(str)-1);
  if length (str)>max then print_string:=copy(str,length(str)-max+1,max) else print_string:=str;;
  until key=#13;
  setcolor (15);
  outtextxy (x,y,print_string);
  setcolor (old_color);
  end;

function getkey: char;
 var key: byte;
 begin
  asm
   mov AH,06h
   mov DL,0FFh
   int 21h
   mov key,AL
  end;
getkey:=chr(key);
end;

end.