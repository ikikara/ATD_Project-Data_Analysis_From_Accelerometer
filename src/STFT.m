function [t,f,stft] = STFT(x, h, frame, overlap, fs)

% Obter o tamanho do sinal
N = length(x);
% Obter o vetor das frequências
if mod(frame, 2)==0
    f_frame = -fs/2:fs/frame:fs/2-fs/frame;
else
    f_frame = -fs/2+fs/(2*frame):fs/frame:fs/2-fs/(2*frame);
end
f = f_frame(f_frame > 0);
% Obter o vetor da janela segundo o vetor das frequências (frame)
h = h(frame); 
% Criar matriz espectral 
stft = [];

% Obter a STFT
for i = 1:frame-overlap:N-frame
    % Aplicar o frame no sinal
    x_framed = x(i:i+frame-1).*h; 
    % Obter a magnitude da dft para o sinal (com frame aplicado)
    dft_framed = abs(fftshift(fft(x_framed)));
    % Adicionar a nova dft cortada so com a parte positiva
    stft = [stft dft_framed(f_frame > 0)];
end

% Obter o vetor tempo
t_frame = frame/fs;
t_overlap = overlap/fs;
t = 0:(t_frame-t_overlap)/60:(t_frame-t_overlap)*(size(stft, 2)-1)/60;
end

