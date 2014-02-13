function output = f_p(beta, mu, Omega)
[r c] = size(beta);
output = 0;
for i=1:c
    output(i) =  - beta(i);%-abs(Omega(i));
    if  mu(i) > 0
        output(i) =  mu(i);
    end
end
end