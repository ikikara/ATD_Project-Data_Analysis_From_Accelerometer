function  plot_signal(x, y, ident_acts, axis, colors, activities)
    eixos=['X' 'Y' 'Z'];
    % Usado só para meter o nome da actividade no sítio certo
    mM = [min(y) max(y)];
    mMi = 1;
    
    xlabel('Time (min)');
    ylabel(['ACC_' eixos(axis)] );
    
    hold on
    plot(x,y,'k')  
    
    % Cada atividade realizada na experiência
    for i=1:length(ident_acts)
       index=ident_acts(i,1);
       str=colors{index};
       
       color = sscanf(str,'%2x%2x%2x',[1 3])/255;
       int=ident_acts(i,2):ident_acts(i,3);
       
       % Dar plot do sinal
       plot(x(int), y(int),  'Color' , color)
       text(x(fix((ident_acts(i,2)+ident_acts(i,3))/2)),  mM(mMi), activities{ident_acts(i,1)}, 'HorizontalAlignment', 'center', 'Clipping', 'on');
       mMi = mod(mMi, 2) + 1;
    end
    hold off
end

