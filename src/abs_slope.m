function S = abs_slope(d, signal)
S = polyfit(d', signal, 1);
S = abs(S(1));
end