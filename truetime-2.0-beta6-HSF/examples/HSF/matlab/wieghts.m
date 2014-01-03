function w = wieghts(n)
total = 0;
for i=1:n
    total = total + i;
end
for i = 1:n
    w(i) = (n-i+1)/total;
end
end