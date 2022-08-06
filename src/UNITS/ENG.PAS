unit eng;

interface

 procedure case_steps(putssign: byte;var px,py:shortint);
 function case_sign (px,py:shortint):byte;

implementation

 function case_sign (px,py:shortint):byte;
 begin
 case px of
 1:case_sign:=2;
 -1:case_sign:=4;
 end;
 case py of
 1:case_sign:=3;
 -1:case_sign:=1;
 end;
 end;

 procedure case_steps(putssign: byte;var px,py:shortint);
 begin
  case putssign of
   1: begin
     case px of
      -1: px:=-px;
       1: begin px:=0;py:=-1;end;
       0: begin
       case py of
        -1: py:=-py;
         1: begin py:=0;px:=-1;end;
       end;
     end;
     end;
    end;
   2: begin
     case px of
       1: px:=-px;
       -1: begin px:=0;py:=-1;end;
       0: begin
       case py of
        -1: py:=-py;
        1: begin py:=0;px:=1;end;
       end;
     end;
     end;
    end;
   3: begin
    case px of
       1: px:=-px;
       -1: begin px:=0;py:=1;end;
       0: begin
       case py of
        1: py:=-py;
        -1: begin py:=0;px:=1;end;
       end;
      end;
     end;
    end;
   4: begin
    case px of
       -1: px:=-px;
       1: begin px:=0;py:=1;end;
       0: begin
       case py of
        1: py:=-py;
        -1: begin py:=0;px:=-1;end;
       end;
     end;
    end;
   end;
  end;
 end;

end.