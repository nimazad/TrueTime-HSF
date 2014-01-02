function [start, length, processor, period] = get_scht (task)
%GET_SCHT gets schedule (starts time and length of time) from a task
%
%Synopsis
% [start, length, processor, period] = GET_SCHT(T)
%
%Description
% Properties:
%  T:
%    - task
%  start:
%    - array of start times
%  length:
%    - array of lengths of time
%  processor:
%    - array of numbers of processor
%  period:
%    - task period 
%
% See also TASK/ADD_SCHT

%   Author(s):  M. Kutil
%   Copyright (c) 2004 CTU FEE
%   $Revision: 1750 $  $Date: 2007-09-20 11:07:47 +0200 (čt, 20 IX 2007) $

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
 

start = task.schStart;
length = task.schLength;
processor = task.schProcessor;
period = task.schPeriod;
%end .. @task/get_scht
