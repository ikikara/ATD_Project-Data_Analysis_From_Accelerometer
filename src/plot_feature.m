function [] = plot_feature(data, ttl, ...
    markers, colors, names, get_feature, get_section, get_domain)

% Número de actividades
n_activities = size(data, 1);
% Criar uma matriz para armazenar uma feature do sinal
feature = cell(3,1);
% Criar uma nova figura
figure;
% Dar títulos
xlabel("X");
ylabel("Y");
zlabel("Z");
title(ttl);
% Dar hold on do plot
hold on
% Dar plot da feature de todas as secções guardadas
for i = 1:n_activities
    % Dar plot da feature de cada secção na actividade
    for j = 1:length(data{i,1})
        % Obter o domínio da secção
        domain = data{i,1}{j};
        if nargin > 7, domain = get_domain(domain); end
        % Obter a feature do sinal para cada dimensão
        for k = 1:3
            % Obter a secção
            section = data{i,k+1}{j};
            if nargin > 6, section = get_section(section); end
            % Obter a feature para a secção e o domínio
            feature{k} = get_feature(domain, section);
        end
        % Avisar se existir NaN valores
        if any(isnan([feature{:}])), disp('NaN value found!'); end
        % Dar plot
        scatter3(feature{:}, markers(i), ...
            'MarkerEdgeColor', ['#' colors{i}]);
    end
end
% Dar legenda do scatter plot
h = zeros(n_activities, 1);
for i = 1:n_activities
    h(i) = scatter3(nan, nan, nan, markers(i), ...
        'MarkerEdgeColor', ['#' colors{i}]);
end
legend(h, names, 'Location', 'northwest');
% Dar hold off do plot
hold off

end

