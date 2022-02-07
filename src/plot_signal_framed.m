function [] = plot_signal_framed(t_lim, x, h, h_names, frame, overlap, ttl)

% Obter o tamanho do sinal
N = length(x);
% Obter número de janelas utilizado
n_h = length(h);
% Criar uma nova figura
figure;
% Dar título à figura
sgtitle(ttl)
% Fazer plot do sinal pelas janelas
for i = 1:n_h
    % Criar um array para guardar os frames
    frames = [];
    % Obter os frames
    for j = 1:frame-overlap:N-frame
        % Aplicar a janela ao sinal e guardar os valores no array de frames
        frames = [frames; x(j:j+frame-1).*h{i}(frame)];
    end
    % Obter o vetor tempo
    t = linspace(t_lim(1), t_lim(2), length(frames));
    % Dar plot do sinal pela janela
    subplot(n_h, 1, i);
    plot(t, frames);
    title(h_names{i});
    xlabel('Time [min]');
    ylabel('Acceleration');
    set(gca, 'XLim', t_lim)
end

end
