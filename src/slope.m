function S = slope(d, signal)
S = polyfit(d', signal, 1);
S = S(1);
end

