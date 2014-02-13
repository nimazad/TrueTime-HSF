function [exectime, data] = ID_code(segment, data)
switch segment
    case 1
            if evalin('base', 'changeAlpha') == 1 && evalin('base', 'changeP') == 1
                changePAlpha(data);            
            else
                changePAlphaOneByOne(data)
            end
            exectime = data.exectime;
    case 2
        exectime = -1;
end
end
function changePAlpha(data)
    myName = strcat('Server',int2str(data.Server));
    operating_bandwidth = evalin('base', 'operating_bandwidth');
    bandwidth_var = evalin('base', 'bandwidth_var');
    operating_period = evalin('base', 'operating_period');
    period_var = evalin('base', 'period_var');
    P = operating_period+period_var/2*(sin(ttCurrentTime()/evalin('base', 'PeriodChange')));
    alpha = operating_bandwidth + bandwidth_var/2*(sin(ttCurrentTime()/evalin('base', 'alphaChange')));
    B = alpha * ceil(P)/100;
    %fprintf('B = %d, P=%d at %d\n', floor(B), ceil(P), ttCurrentTime())
    ttSetCBSParameters(myName, (B), ceil(P));    
end

function changePAlphaOneByOne(data)
    myName = strcat('Server',int2str(data.Server));
    operating_bandwidth = evalin('base', 'operating_bandwidth');
    bandwidth_var = evalin('base', 'bandwidth_var');
    operating_period = evalin('base', 'operating_period');
    period_var = evalin('base', 'period_var');
    if evalin('base', 'changeP')
        P = operating_period+period_var/2*(sin(ttCurrentTime()/evalin('base', 'PeriodChange')));
        alpha = operating_bandwidth;
    else
        P = operating_period;
        alpha = operating_bandwidth + bandwidth_var/2*(sin(ttCurrentTime()/evalin('base', 'alphaChange')));
    end
    
    B = alpha * ceil(P)/100;
    %fprintf('B = %d, P=%d at %d\n', floor(B), ceil(P), ttCurrentTime())
    ttSetCBSParameters(myName, (B), ceil(P));    
end



