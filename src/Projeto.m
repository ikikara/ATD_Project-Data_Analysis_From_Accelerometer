%%
%1)
format long;

path = 'data\';
files = {'acc_exp09_user05' 'acc_exp10_user05' 'acc_exp11_user06' ...
    'acc_exp12_user06' 'acc_exp13_user07' 'acc_exp14_user07' ...
    'acc_exp15_user08' 'acc_exp16_user08' 'labels'};

n_activities = 12;
dyn_activities = 1:3;
sta_activities = 4:6;
trans_activities = 7:12;

activities = {'Walking' 'Walking_Upstairs' 'Walking_Downstairs' ...
                'Sitting' 'Standing' 'Laying' ...
                'Stand_to_sit' 'Sit_to_stand' 'Sit_to_lie' 'Lie_to_sit'...
                'Stand_to_lie' 'Lie_to_stand'};

colors = {'5a79d2' '2356ea' '8597c9' 'f0d725' 'f08425' 'f03025' ...
    '25f076' '37a765' '1f7c46', '83e66e', '4fb938', '165e07'};

fs = 50;
%disp_files_perU = 2;
analyse_file = 2; %Usado no 3.1 para testar as janelas

x=cell(1,8);

for i=1:9
    filename =[path files{i} '.txt'];
    if(i==9)
        labels = importdata(filename,' ');
    else
        x{i} = importdata(filename,' ');
    end
end




%%
% 2) 

data = cell(n_activities, 4);
data(:) = {{}};
for i = 1:length(x)
    % Obter o nº da experiência e o utilizador correspondente
    file_ids = sscanf(files{i}, 'acc_exp%d_user%d');

    file_labels = labels(labels(:,1)==file_ids(1) & ...
                labels(:,2)==file_ids(2), 3:end);
    % Vetor de tempo
    t=(0:length(x{i})-1/fs/60);
    
    for j = 1:length(file_labels)
        % Intervalo de ocorrência de determinada experiência
        interval = file_labels(j,2):file_labels(j,3);
        % Guardar o vetor de tempo em função do intervalo obtido
        data{file_labels(j,1),1} = [data{file_labels(j,1),1}; t(interval)];
        % Guardar nas últimas 3 colunas as coordenadas correspondentes
        for k = 1:3    
            data{file_labels(j,1),k+1} = ...
           [data{file_labels(j,1),k+1}; x{i}(interval,k)];
        end
    end



    % Obter o nº da experiência e o utilizador correspondente
    file_ids = sscanf(files{i}, 'acc_exp%d_user%d');
    file_labels = labels(labels(:,1) == file_ids(1) & ...
        labels(:,2) == file_ids(2),3:end);
    % Vetor de tempo
    N = length(x{i});
    t = (0:N-1)/fs/60;
    % Criar uma figura
    figure
    % Fazer plot das 3 dimensões no mesmo gráfico
    sgtitle(files{i})
    for j = 1:3
        subplot(3, 1, j);
        plot_signal(t, x{i}(:,j), file_labels, j, colors, activities);
    end
end

%%
% 3.1) AD -> Walking_Downstairs) (+/- percebido, ver frame e overlap)

activity = dyn_activities(3);

% Obter o tamanho do sinal
N = size(x{analyse_file}, 1);
disp(N);
% Definir a propriedades do frame (windows)
frame = fix(N*0.1);
overlap = fix(frame/2);

% Dar plot do sinal com diferentes janelas
plot_signal_framed([0 (N-1)/fs/60], x{analyse_file}(:,2), ...
    {@rectwin, @hamming, @hann}, {'Rectangular', 'Hamming', 'Hann'}, ...
    frame, overlap, 'Different frame functions effects on a signal');



% Dar plot da ativitidade Walking_Downstairs com diferentes janelas
plot_signal_dft_framed(data{activity,1}{activity}, data{activity,3}{activity}, ...
    {@rectwin, @hamming, @hann}, {'Rectangular', 'Hamming', 'Hann'}, ...
    fs, 'Different frame functions effects on the |DFT|', ...
    colors{activity});

%%
% 3.2)
for i=1:length(x)
    file_ids = sscanf(files{i}, 'acc_exp%d_user%d');
    file_labels = labels(labels(:,1) == file_ids(1) & ...
        labels(:,2) == file_ids(2),3:end);
    % Obter o vetor tempo
    N = length(x{i});
    % Criar uma nova figura
    figure
    % Dar plot nos 3 eixos de todas as atividades da experiência em
    % questão
    plot_acc_dft(x{i}, file_labels, colors, activities, fs, @hann, files{i});
end

%%
% 3.3) FAZER  (TEORICO)

%%
% 3.4) 

display_names = {'Walking', 'Walking Upstairs', 'Walking Downstairs'};

for i=1:length(x)
    disp(['Média e desvio padrão no ' files{i}])
    file_ids = sscanf(files{i}, 'acc_exp%d_user%d');
    % Criar um array é para uma atividade diferente 
    array1=[];
    array2=[];
    array3=[];
    for j=1:length(labels)
        if(labels(j,1)==file_ids(1) && labels(j,2)==file_ids(2))
            if(labels(j,3)==1)
                % Intervalo da atividade em questão
                interval=labels(j,4):labels(j,5);
                % Contar o número de passos
                n_steps=steps_counter([x{1,i}(interval, 1), x{1,i}(interval, 2), x{1,i}(interval, 3)], fs);
                % Multiplica para dar os passos por minuto
                array1=[array1 n_steps*60];
            elseif(labels(j,3)==2)
                interval=labels(j,4):labels(j,5);
                n_steps=steps_counter([x{1,i}(interval, 1), x{1,i}(interval, 2), x{1,i}(interval, 3)], fs);
                array2=[array2 n_steps*60];
            elseif(labels(j,3)==3)
                interval=labels(j,4):labels(j,5);
                n_steps=steps_counter([x{1,i}(interval, 1), x{1,i}(interval, 2), x{1,i}(interval, 3)], fs);  
                array3=[array3 n_steps*60];
            end
        end
    end
    disp([display_names{1} ': ' num2str(mean(array1)) ' +- ' num2str(std(array1))])
    disp([display_names{2} ': ' num2str(mean(array2)) ' +- ' num2str(std(array2))])
    disp([display_names{3} ': ' num2str(mean(array3)) ' +- ' num2str(std(array3))])
    disp(" ")
end


%%
% 3.5)  Atividades Dinamicas

% Considerar as atividades dinâmicas (índices)
index_dyn = dyn_activities;
% Dar plot dos sinais 
plot_activities(data(index_dyn,:), 'Dynamic Activities', ...
    colors(index_dyn), activities(index_dyn));

% Dar plot da |DFT| do sinal a partir da distância média entre os picos (7% threshold)
plot_feature(data(index_dyn,:), 'Average DFT Peak Interval (7% threshold)', ...
    'o*d', colors(index_dyn), activities(index_dyn), ...
    @avg_07_peak_interval, @dft_magnitude, @frequency);

% Dar plot das médias do sinal
plot_feature(data(index_dyn,:), 'Signal Average', 'o*d', ...
    colors(index_dyn), activities(index_dyn), @avg);

% Dar plot dos slopes do sinal
plot_feature(data(index_dyn,:), 'Signal Slope', 'o*d', colors(index_dyn), ...
    activities(index_dyn), @slope);

%%
% 3.5) Atividades Estáticas

% Considerar as atividades estáticas (índices)
index_sta = sta_activities;
% Dar plot dos sinais
plot_activities(data(index_sta,:), 'Static Activities', ...
    colors(index_sta), activities(index_sta));

% Dar plot da |DFT| do sinal a partir da distância média entre os picos (7% threshold)
plot_feature(data(index_sta,:), 'Average DFT Peak Interval (7% threshold)', ...
    'o*d', colors(index_sta), activities(index_sta), ...
    @avg_07_peak_interval, @dft_magnitude, @frequency);

% Dar plot das médias do sinal
plot_feature(data(index_sta,:), 'Signal Average', 'o*d', ...
    colors(index_sta), activities(index_sta), @avg);

% Dar plot dos slopes do sinal
plot_feature(data(index_sta,:), 'Signal Slope', 'o*d', colors(index_sta), ...
    activities(index_sta), @slope);

%%
% 3.5) Atividades de Transição

% Considerar as atividades de transição (índices)
index_trans = trans_activities;
% Dar plot dos sinais
plot_activities(data(index_trans,:), 'Transition Activities', ...
    colors(index_trans), activities(index_trans));

% Dar plot da |DFT| do sinal a partir da distância média entre os picos (7% threshold)
plot_feature(data(index_trans,:), 'Average DFT Peak Interval (7% threshold)', ...
    'o*dsxp', colors(index_trans), activities(index_trans), ...
    @avg_07_peak_interval, @dft_magnitude, @frequency);

% Dar plot das médias do sinal
plot_feature(data(index_trans,:), 'Signal Average', 'o*dsxp', ...
    colors(index_trans), activities(index_trans), @avg);

% Dar plot dos slopes do sinal
plot_feature(data(index_trans,:), 'Signal Slope', 'o*dsxp', colors(index_trans), ...
    activities(index_trans), @slope);

%%
% 3.6) 

plot_activities(data, 'All Activities', colors, activities);

% Dar plot do valor absoluto dos slopes do sinal
plot_feature(data, 'Signal Absolute Slope', 'oooddd******', colors, activities, @abs_slope);

% Dar plot do valor amplitude do sinal
plot_feature(data, 'Amplitude', 'oooddd******', colors, activities, @amplitude);



%%
% 4.1) e 4.2) 

    % Obter o nº da experiência e o utilizador correspondente
    file_ids = sscanf(files{analyse_file}, 'acc_exp%d_user%d');
    file_labels = labels(labels(:,1) == file_ids(1) & ...
        labels(:,2) == file_ids(2),3:end);

    % Obter o vetor tempo
    N = length(x{analyse_file}); 
    t = (0:N-1)/fs/60;
    % Dar plot do eixo Z do sinal
    figure;
    subplot(2, 1, 1);
    plot_signal(t, x{analyse_file}(:,3), file_labels, 3, colors, activities);
    title('Original Signal');

    % Obter a stft e os vetores tempo e de frequência
    frame = fix(N*0.005);
    overlap = fix(frame/2);
    [t,f,stft] = STFT(x{analyse_file}(:,3), @hann, frame, ...
        overlap, fs);
    % Dar plot da stft
    subplot(2, 1, 2);
    imagesc(t, f, 20*log10(stft));
    set(gca, 'YDir', 'normal');
    title('Short Time Fourier Transform (STFT)');
    xlabel('Time [min]');
    ylabel('Frequency [Hz]');
    c = colorbar;
    c.Label.String = 'Power [dB]';
