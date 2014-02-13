function [exectime, data] = ID_code(segment, data)
switch segment
    case 1
        adaptBudget(data);
        adaptPeriod(data);
%         
%         myName = strcat('Server',int2str(data.Server));
%         Budgets = evalin('base', 'Budgets');        
%         Periods = evalin('base', 'Periods');
%         [row col] = size(Budgets(data.Server,:));
%         Budgets(data.Server, col+ 1) = ttGetCBSBudget(myName);
%         Periods(data.Server, col+ 1) = ttGetCBSPeriod(myName);
%         assignin('base','Budgets',Budgets);
%         assignin('base','Periods',Periods);        
%         adaptTime = evalin('base', 'adaptTime');
%         [row col] = size(adaptTime(data.Server,:));
%         adaptTime(data.Server, col+ 1) = ttCurrentTime();
%         assignin('base','adaptTime',adaptTime);
        exectime = data.exectime;
    case 2
        exectime = -1;
end
end
function adaptBudget(data)
myName = strcat('Server',int2str(data.Server));
Qs = 16+4*(sin(ttCurrentTime()/evalin('base', 'BudgetChange')));
ttSetCBSParameters(myName, Qs, ttGetCBSPeriod(myName));
end

function adaptPeriod(data)
myName = strcat('Server',int2str(data.Server));
P = 25+5*(sin(ttCurrentTime()/evalin('base', 'PeriodChange')));
ttSetCBSParameters(myName, ttGetCBSBudget(myName), P);
end

