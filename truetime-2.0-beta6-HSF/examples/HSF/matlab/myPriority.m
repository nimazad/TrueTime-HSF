
function p = myPriority(periods, myID)
myPeriod = periods(myID);
periods = sort(periods);
p = 0;
for i=1:length(periods)
    if myPeriod == periods(i);
        p = i;
    end
end