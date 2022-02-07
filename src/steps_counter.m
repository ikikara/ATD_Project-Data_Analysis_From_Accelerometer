function n_steps_second = steps_counter(signal, fs)

% Obter o tamanho do sinal
N = size(signal, 1);
% Criar matriz para a aceleração das componentes do utilizador e
% gravitacional
acc_u = zeros(3, N);
acc_g = zeros(3, N);
% Obter as componentes do utilizador e gravitacional para cada dimensão da
% secção
for k = 1:3
    % obter a componente gravitacional ignorando o sinal  (< 0.2 Hz)
    acc_g(k,:) = lowpass(signal(:,k), 0.2, fs);
    % obter a componente do usuário subtraindo a gravidade ao sinal bruto 
    acc_u(k,:) = signal(:,k)'-acc_g(k,:);
end
% Obter a aceleração gravitacional
acc_v = dot(acc_g, acc_u);
% Obter o vetor das frequências
if mod(N, 2) == 0
    f = -fs/2:fs/N:fs/2-fs/N;
else
    f = -fs/2+fs/(2*N):fs/N:fs/2-fs/(2*N);
end
% Obter a dft da aceleração gravitacional
dft = abs(fftshift(fft(acc_v)));
% Cortar a parte não positiva da dft
dft = dft(f > 0);
f = f(f > 0);
% Obter passos por segundo a partir do primeiro pico relevante da dft 
threshold = max(dft)*0.3;
[~,peaks_i] = findpeaks(dft, 'MinPeakHeight', threshold);
peak_i = peaks_i(1);
n_steps_second = f(peak_i);

end