function [exectime, data] = ctrl_code(segment, data)

switch segment
    case 1
        data.NoJobs = data.NoJobs + 1;
        %y = ttAnalogIn(1);
        %data.u = -data.K * y;
        
        ttSetData(data.myName, data);
        if strcmp(data.myName,'S2T2')
            %currentExectime = data.exectime + data.exectime * abs(sin(((pi/180)*ttCurrentTime())));%rand*data.exectime;
            currentExectime = normrnd((data.exectime*2)/3, data.exectime/10);
            if ttCurrentTime()>100
                currentExectime = normrnd((data.exectime*3), data.exectime/10);
            end
            ttAnalogOut(13, currentExectime);
        else
            currentExectime = data.exectime;
        end
        exectime = currentExectime;
    case 2
        %ttAnalogOut(1, data.u)
        data.sumExectime = data.sumExectime + data.exectime;   
        ttSetData(data.myName, data);
        exectime = -1;
end
