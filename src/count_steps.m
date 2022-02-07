function n_steps_second = count_steps(signal, fs)

% get size of signal
N = size(signal, 1);
% create acceleration matrices for user and gravity components
acc_u = zeros(3, N);
acc_g = zeros(3, N);
% get user and gravity components for each dimension in section
for k = 1:3
    % get gravity component by lowpassing the signal (< 0.2 Hz)
    acc_g(k,:) = lowpass(signal(:,k), 0.2, fs);
    % get user component by subtracting gravity to raw signal
    acc_u(k,:) = signal(:,k)'-acc_g(k,:);
end
% get vertical acceleration
acc_v = dot(acc_g, acc_u);
% get frequency vector
if mod(N, 2) == 0
    f = -fs/2:fs/N:fs/2-fs/N;
else
    f = -fs/2+fs/(2*N):fs/N:fs/2-fs/(2*N);
end
% get dft of vertical acceleration
dft = abs(fftshift(fft(acc_v)));
% cut dft and frequency non-positive parts
dft = dft(f > 0);
f = f(f > 0);
% get steps per second from first relevant peak of dft
threshold = max(dft)*0.3;
[~,peaks_i] = findpeaks(dft, 'MinPeakHeight', threshold);
peak_i = peaks_i(1);
n_steps_second = f(peak_i);

end

