unit my_crt;

interface
uses
 graph;

procedure button_draw (x1,y1,x2,y2: integer;press:boolean;text:string);
procedure frame (x,y,x1,y1:integer);

implementation

procedure button_draw (x1,y1,x2,y2: integer;press:boolean;text:string);
begin
 setfillstyle (1,7);
 bar (x1,y1,x2,y2);
 setcolor (0);
 outtextxy(round(x1+(x2-x1)/2-length(text)*4+1),round(y1+(y2-y1)/2)-3,text);
 setcolor (8);
 rectangle (x1,y1,x2,y2);
 if not press then
 begin
  setcolor (15);
  line (x2,y1,x2,y2);
  line (x1,y1,x1,y2);
 end;
end;

procedure frame (x,y,x1,y1:integer);
begin
 setcolor (15);
 rectangle (x,y,x1,y1);
 setcolor (7);
 rectangle (x-1,y-1,x1+1,y1+1);
end;

end.