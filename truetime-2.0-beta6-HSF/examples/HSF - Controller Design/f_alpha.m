function output = f_alpha(beta, mu)
[r c] = size(beta);
output = 0;
for i=1:c
    if mu(i) > 0 
        output(i) = mu(i);
    else
        output(i) = -beta(i);
    end
end
end