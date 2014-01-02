function display(TS)
%DISPLAY   Display Set of Tasks
%
% Syntax
%    DISPLAY(TS)

%   Author(s):  M. Kutil
%   Copyright (c) 2004 CTU FEE
%   $Revision: 207 $  $Date: 2005-08-08 17:41:44 +0200 (po, 08 VIII 2005) $

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
 

disp(['Set of ',int2str(size(TS.tasks, 2)),' tasks']);
% prec
if ~isempty(find(TS.Prec))
  disp([' There are precedence constraints']);
end
% schedule
schedule = TS.schedule;
if (schedule.is)
  disp([' There is schedule: ', get(TS,'scheduledesc')]);
  % period
  period = schparam(TS,'period');
  if ~isempty(period)
	  disp(['   Tasks period: ', num2str(period)]);
  end
  % solving time
  if ~isempty(schedule.time)
      if length(schedule.time)==1
          disp(['   Solving time: ', num2str(schedule.time), 's']);
      else
          disp(['   SUM solving time: ', num2str(sum(schedule.time)), 's']);
          disp(['   MAX solving time: ', num2str(max(schedule.time)), 's']);          
      end
  end
  % iterations
  if ~isempty(schedule.iterations)
      disp(['   Number of iterations: ', num2str(schedule.iterations)]);
  end
  % memory
  if ~isempty(schedule.memory)
      if length(schedule.memory)==1
          disp(['   Memory alocation: ', num2str(schedule.memory), 'B']);
      else
          disp(['   SUM memory alocation: ', num2str(sum(schedule.memory)), 's']);
          disp(['   MAX memory alocation: ', num2str(max(schedule.memory)), 's']);          
      end         
  end
end
%end .. @taskset/display
