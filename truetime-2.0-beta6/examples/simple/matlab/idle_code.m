function [exectime, data] = idle_code(segment, data)

switch segment
    case 1
        S = data.Server;
        ttGetCPUTime(data.myName);
        exectime = data.exectime;
    case 2
        exectime = -1;
end