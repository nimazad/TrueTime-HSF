% LISTSCH_DEMO Demo application of the scheduling with 'P|prec|Cmax' notation
%
%    See also LISTSCH

%   Author(s): M. Kutil, M. Stibor
%   Copyright (c) 2005 CTU FEE
%   $Revision: 1518 $  $Date: 2007-09-14 14:06:48 +0200 (pá, 14 IX 2007) $

% This file is part of Scheduling Toolbox.
%
% Scheduling Toolbox is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation; either version 2 of the
% License, or (at your option) any later version.
%
% Scheduling Toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Scheduling Toolbox; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
% USA

% test of listsch05

clc;
disp('Demo of list scheduling algorithm.');
disp('--------------------------------------------------');


t1 = task('t1',1,10);
t2 = task('t2',1,13);
t3 = task('t3',2,8);
t4 = task('t4',2,8);
t5 = task('t5',4,10);
t6 = task('t6',5,12);
t7 = task('t7',7,3);
t8 = task('t8',3,0);
t9 = task('t9',7,0);
T = taskset([t1 t2 t3 t4 t5 t6 t7 t8 t9]);
T = colour(T);
TT = T;
TT.ReleaseTime = 0*TT.ReleaseTime;

% simple listsch
T0=listsch(T,problem('P|prec|Cmax'),2);
T1=listsch(T,problem('P|rj|sumCj'),2,'EST');
T2=listsch(T,problem('P|rj|sumCj'),2,'ECT');
T3=listsch(T,problem('P|prec|Cmax'),2,'LPT');
T4=listsch(T,problem('P|prec|Cmax'),2,'SPT');
TT0=listsch(TT,problem('P|prec|Cmax'),2);
TT1=listsch(TT,problem('P|rj|sumCj'),2,'EST');
TT2=listsch(TT,problem('P|rj|sumCj'),2,'ECT');
TT3=listsch(TT,problem('P|prec|Cmax'),2,'LPT');
TT4=listsch(TT,problem('P|prec|Cmax'),2,'SPT');

figure;
subplot(6,2,1);
plot(T,'axis',[nan 31]);
title('UnSchedule taskset #1');
subplot(6,2,2);
plot(TT,'axis',[nan 21]);
title('UnSchedule taskset #2');

subplot(6,2,3);
plot(T0,'axis',[nan 31]);
title('List scheduling');
subplot(6,2,4);
plot(TT0,'axis',[nan 21]);
title('List scheduling');

subplot(6,2,5);
plot(T1,'axis',[nan 31])
title('Strategy EST');
subplot(6,2,6);
plot(TT1,'axis',[nan 21])
title('Strategy EST');


subplot(6,2,7);
plot(T2,'axis',[nan 31])
title('Strategy ECT');
subplot(6,2,8);
plot(TT2,'axis',[nan 21])
title('Strategy ECT');

subplot(6,2,9);
plot(T3,'axis',[nan 31])
title('Strategy LPT');
subplot(6,2,10);
plot(TT3,'axis',[nan 21])
title('Strategy LPT');

subplot(6,2,11);
plot(T4,'axis',[nan 31])
title('Strategy SPT');
subplot(6,2,12);
plot(TT4,'axis',[nan 21])
title('Strategy SPT');
