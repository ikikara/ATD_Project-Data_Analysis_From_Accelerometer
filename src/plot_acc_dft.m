function plot_acc_dft(y, ident_acts, colors, activities, fs, h, filename)
    eixos=['X' 'Y' 'Z'];
    
    sgtitle(['|DFT| of activities for: ' filename])
    hold on   
    
    % Cada dimensão
    for k=1:3   
        % Cada atividade realizada na experiência
        for i=1:length(ident_acts)
           ylabel(['ACC_' eixos(k)] );
           xlabel('Time (min)');
           subplot(3, length(ident_acts), (k-1)*length(ident_acts)+i);
           index=ident_acts(i,1);
           str=colors{index};

           color = sscanf(str,'%2x%2x%2x',[1 3])/255;
           int=ident_acts(i,2):ident_acts(i,3);

           % Obter o tamanho do sinal
           N = length(int);
           % Obter o vetor das frequências
           if mod(N, 2) == 0
               f = -fs/2:fs/N:fs/2-fs/N;
           else
               f = -fs/2+fs/(2*N):fs/N:fs/2-fs/(2*N);
           end
            
           %Dar plot da dft
           plot(f, abs(fftshift(fft(y(int, k).*h(N)))), 'Color' , color)
           title(activities(index));
        end
        hold off
    end
end




