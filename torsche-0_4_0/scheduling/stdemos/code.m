function [exectime,data] = code(seg,data) 
% 
% This document was automatically generated by Code Generator for Scheduling toolbox 
% 

 i=floor(ttCurrentTime/ttGetPeriod); 
 
switch(seg) 
case 1
       data.reg12 = data.units.unit5(2); %T12 Out
       ttAnalogOut(1,data.units.unit5(2));
       data.units.unit3(1) = ttAnalogIn(1)*data.const2; %T1
       data.units.unit6(1) = ifmax(data.reg2,data.const9); %T2
       data.units.unit1(1) = data.reg8; %T6
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 2
       data.reg3 = data.units.unit6(2) ; %T2 Out
       data.reg9 = data.units.unit1(2) ; %T6 Out
       data.units.unit5(1) = ifmin(data.reg3,data.const8); %T3
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 3
       data.reg11 = data.units.unit3(3) ; %T1 Out
       data.reg4 = data.units.unit5(2) ; %T3 Out
       data.units.unit3(1) = data.const11*data.reg11; %T7
       data.units.unit2(1) = data.reg11+data.reg4; %T9
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 4
       data.units.unit3(1) = data.const10*data.reg11; %T4
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 5
       data.reg8 = data.units.unit3(3) ; %T7 Out
       data.units.unit2(1) = data.reg8-data.reg9; %T8
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 6
       data.reg1 = data.units.unit3(3) ; %T4 Out
       data.units.unit2(1) = data.reg1+data.reg4; %T5
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 7
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 8
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 9
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 10
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 11
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 12
       data.reg5 = data.units.unit2(10) ; %T9 Out
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 13
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 14
       data.reg10 = data.units.unit2(10) ; %T8 Out
       data.units.unit2(1) = data.reg5+data.reg10; %T10
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 15
       data.reg2 = data.units.unit2(10) ; %T5 Out
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 16
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 17
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 18
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 19
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 20
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 21
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 22
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 23
       data.reg6 = data.units.unit2(10) ; %T10 Out
       data.units.unit6(1) = ifmax(data.reg6,data.const6); %T11
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 24
       data.reg7 = data.units.unit6(2) ; %T11 Out
       data.units.unit5(1) = ifmin(data.reg7,data.const7); %T12
       data.units=pipeunit(data.units);
       exectime = 1/data.frequency;
case 25
       exectime = -1;
end 

function u=pipeunit(u)
        %  unit null
       for i=1:1
              u.unit1(3 - i) =  u.unit1(2 - i); 
       end
       u.unit1(1)=0;
        %  unit +
       for i=1:9
              u.unit2(11 - i) =  u.unit2(10 - i); 
       end
       u.unit2(1)=0;
        %  unit *
       for i=1:2
              u.unit3(4 - i) =  u.unit3(3 - i); 
       end
       u.unit3(1)=0;
        %  unit /
       for i=1:2
              u.unit4(4 - i) =  u.unit4(3 - i); 
       end
       u.unit4(1)=0;
        %  unit ifmin
       for i=1:1
              u.unit5(3 - i) =  u.unit5(2 - i); 
       end
       u.unit5(1)=0;
        %  unit ifmax
       for i=1:1
              u.unit6(3 - i) =  u.unit6(2 - i); 
       end
       u.unit6(1)=0;
        %  unit null
       for i=1:1
              u.unit7(3 - i) =  u.unit7(2 - i); 
       end
       u.unit7(1)=0;
        %  unit zero
       for i=1:1
              u.unit8(3 - i) =  u.unit8(2 - i); 
       end
       u.unit8(1)=0;
return
function y=ifmin(a1,a2)
    if(a1<a2)
y=a2;
else
y=a1;
end
return

function y=ifmax(a1,a2)
    if(a1>a2)
y=a2;
else
y=a1;
end
return

