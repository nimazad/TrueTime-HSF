function vectU = UUniFast(n, U)
sumU = U;
for i=1:n-1
    nextSumU = sumU.*rand^(1/(n-i));
    vectU(i) = sumU - nextSumU;
    sumU = nextSumU;
end
vectU(n) = sumU;
end