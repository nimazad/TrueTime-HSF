function [exectime, data] = Idle_code(segment, data)

switch segment
    case 1
        exectime = data.exectime;
    case 2
        exectime = -1;
end