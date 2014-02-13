clear
contextSwitchOverhead = 0;
Header;
simTime = simTime/10;
identification = 0;
Adaptive = 0;
changeAlpha = 0;
changeP = 0;
tmpPeriod = 1;
sim('HSF.mdl', simTime)
Parameters;
baseBeta = sum(beta);

contextSwitchOverhead = .7;
totalCnt = 16;
for myCnt = totalCnt:-1:1
    Header;
    simTime = simTime/10;
    identification = 0;
    Adaptive = 0;
    changeAlpha = 0;
    changeP = 0;
    tmpPeriod = myCnt/4;
    sim('HSF.mdl', simTime)
    Parameters;
    total_beta(myCnt) = sum(beta);
    tmpActPeriod(totalCnt-myCnt+1) = 20*myCnt/4;
end
plot(tmpActPeriod, 100.*(baseBeta-total_beta)./simTime)    



return

totalCnt = 15;
for myCnt = 1:totalCnt
    Header;
    simTime = simTime/10;
    identification = 0;
    Adaptive = 0;
    changeAlpha = 0;
    changeP = 0;
    contextSwitchOverhead = myCnt*.05-.05;
    sim('HSF.mdl', simTime)
    Parameters;
    total_beta(myCnt) = sum(beta);
end
plot([1:totalCnt].*0.05-.05, 100.*(total_beta(1)-total_beta)./simTime)    