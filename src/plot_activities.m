function [] = plot_activities(data, ttl, colors, names, ...
    get_section, get_domain)

% Número de actividades
n_activities = size(data, 1);
% Criar nova figura
figure;
% Titulo do plot
sgtitle(ttl);

% Dar plot de todas as dimensões de uma seção de cada atividade 
for i = 1:n_activities
    % Escolher uma secção random
    section_i = randi([1 length(data{i,1})], 1);
    % Obter o domínio da secção
    domain = data{i,1}{section_i};
    if nargin > 5
        domain = get_domain(domain);
    end
    % Dar plot de todas dimensões da secção
    for j = 1:3
        % Criar um subplot para guardar as atividades 
        subplot(3, n_activities, (j-1)*n_activities+i);
        % Obter a secção
        section = data{i,j+1}{section_i};
        if nargin > 4
            section = get_section(section);
        end
        % Dar plot da secção
        plot(domain, section, 'Color', ['#' colors{i}]);
        % % Titulo do subplot
        title([names{i} ' ' char(87+j)]);
        set(gca, 'XLim', [domain(1) domain(end)])
    end
end

end

