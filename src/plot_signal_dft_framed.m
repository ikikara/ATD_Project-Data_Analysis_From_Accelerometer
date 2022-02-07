function [] = plot_signal_dft_framed(t, x, h, h_names, fs, ttl, color)

% Obter o tamanho do sinal
N = length(t);
% Obter número de janelas utilizado
n_h = length(h);
% Obter o vetor de frequência
if mod(N, 2) == 0
    f = -fs/2:fs/N:fs/2-fs/N;
else
    f = -fs/2+fs/(2*N):fs/N:fs/2-fs/(2*N);
end

% Criar uma nova figura
figure
% Dar título à figura
sgtitle(ttl);
for i = 1:n_h
    % Dar plot do sinal pela janela
    subplot(n_h, 2, (i-1)*2+1);
    plot(t, x.*h{i}(N), 'Color', ['#' color]);
    title(['Original signal in ' h_names{i} ' frame']);
    set(gca, 'XLim', [t(1) t(end)]);
    xlabel('Time [min]');
    ylabel('Acceleration');
    % Dar plot da dft do sinal pela janela
    subplot(n_h, 2, (i-1)*2+2);
    plot(f, abs(fftshift(fft(x.*h{i}(N)))), 'Color', ['#' color]);
    title(['|DFT| in ' h_names{i} ' frame']);
    set(gca, 'XLim', [f(1) f(end)]);
    xlabel('Frequency [Hz]');
    ylabel('Magnitude');
end

end