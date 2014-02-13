function [exectime, data] = Idle_code(segment, data)

switch segment
    case 1
        exectime = data.exectime;
%          fprintf('%s started at %d<Idle code>\n',data.myName, ttCurrentTime())
    case 2
        exectime = -1;
%          fprintf('%s finished at %d<Idle code>\n',data.myName, ttCurrentTime())
end