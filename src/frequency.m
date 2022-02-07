function f = frequency(time)
fs = 50;
N = length(time);
if mod(N, 2) == 0
    f = -fs/2:fs/N:fs/2-fs/N;
else
    f = -fs/2+fs/(2*N):fs/N:fs/2-fs/(2*N);
end
end