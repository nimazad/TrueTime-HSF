function y = Membership(x, startPoint, maxPoint, endPoint)
    if (x>=startPoint && x < maxPoint)
        y = (1/(maxPoint-startPoint)) * (x - startPoint);
    elseif(x>=maxPoint && x <= endPoint)
        y = (-1/(endPoint-maxPoint)) * (x - maxPoint) + 1;
    else
        y = 0;
    end;
end