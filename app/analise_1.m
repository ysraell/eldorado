clear all
close all
clc

%%% Pre-formatacao
%%% cat data.csv |sed -e 's/\,/\./g' |sed -e 's/NA/nan/g' >data_mod.csv

data = importdata('data_mod.csv');

alvo = data(:,1);
hora = data(:,2);
mes = data(:,3);
ano = data(:,4);
entradas = data(:,5:end);

% figure;
% plot(alvo)
% 
% figure;
% hist(hora)
% 
% figure;
% hist(mes)
% 
% figure;
% hist(ano)
% 
% T = size(entradas,2);
% for i=5:T
%     figure;
%     hist(entradas(:,i))
% end

%%% Para as linhas nas quais algo ~= NaN, replica linha anterior nos casos de
%%% NaN para o mês e ano.

T = size(entradas,1);
Y = zeros(sum(~isnan(alvo)),3);
s=1;
Y(1,:) = [alvo(1) mes(1) ano(1)];
na_mes=0;
na_ano=0;
for i=2:T
    if ~isnan(alvo(i))
        if isnan(mes(i))
            mes(i) = mes(i-1);
            na_mes=na_mes+1;
        end
        if isnan(ano(i))
            ano(i) = ano(i-1);
            na_ano=na_ano+1;
        end
        s=s+1;
        Y(s,:) = [alvo(i) mes(i) ano(i)];
    else
        if isnan(mes(i))
            mes(i) = mes(i-1);
        end
        if isnan(ano(i))
            ano(i) = ano(i-1);
        end
    end
end
Ts=s;

% sum(isnan(Y(:))) -> 0

%%% Criando tabela mes x ano
%%% unique(ano) [2007 2017]
%%% unique(mes) [1 12]

% [mean sd min max]
[a,b]=hist(ano,unique(ano));
anos = [b a'];
Ta = size(anos,1);
[a,b]=hist(mes,unique(mes));
meses = [b a'];
Tb = size(meses,1);
nP = 5;
X = zeros(Tb,Ta,nP);
l=0;
Z = zeros(Ta*Tb,nP);
for j=1:Ta
    disp(anos(j,1))
    for i=1:Tb
        disp(meses(i,1))
        a = (anos(j,1)==Y(:,3));
        b = (meses(i,1)==Y(:,2));
        clear tmp
        tmp = zeros(sum(a.*b),1);
        k=0;
        for s=1:Ts
            if (anos(j,1)==Y(s,3))&&(meses(i,1)==Y(s,2))
                k=k+1;
                tmp(k) = Y(s,1);
            end
        end
        X(i,j,1) = mean(tmp);
        X(i,j,2) = std(tmp);
        X(i,j,3) = min(tmp);
        X(i,j,4) = max(tmp);
        X(i,j,5) = median(tmp);
        
        l=l+1;
        Z(l,1) = mean(tmp);
        Z(l,2) = std(tmp);
        Z(l,3) = min(tmp);
        Z(l,4) = max(tmp);
        Z(l,5) = median(tmp);
    end
end

% close all
% for i=1:5
%     figure;
% %     contourf(anos(:,1),meses(:,1),X(:,:,i))
%     imagesc(anos(:,1),meses(:,1),X(:,:,i))
%     contourcbar
%     ylabel('meses')
%     xlabel('anos')
%     zlabel('Alvo')
% end
% figure(1)
% title('M\''{e}dia','Interpreter','latex')
% figure(2)
% title('Desv. padr\~{a}o','Interpreter','latex')
% figure(3)
% title('M\''{i}nimo','Interpreter','latex')
% figure(4)
% title('M\''{a}ximo','Interpreter','latex')
% figure(5)
% title('M\''{e}diana','Interpreter','latex')
% 
% 
% figure;
% hold on
% %plot(Z(:,5),'g.-')
% plot(Z(:,3),'k--')
% plot(Z(:,4),'r--')
% errorbar(Z(:,1),Z(:,2),'xg--')
% plot(Z(:,1))
% lgd = legend('mim','max','desvio','m\''{e}dia');
% set(lgd,'Interpreter','latex')
% ylabel('alvo')
% xlabel('tempo (meses)')
% grid
% title('S\''{e}rie hist\''{o}rica','Interpreter','latex')
% hold off

%%% Avaliacao direta dos valores de Alvo pelo tempo resultou em observao
%%% apenas de padroes mensais e nao anuais.

% close all
% for i=1:5
%     figure;
%     periodogram(Z(:,i),'power');figure(gcf)
% end
% figure(1)
% title('Frquencial: M\''{e}dia','Interpreter','latex')
% figure(2)
% title('Frquencial: Desv. padr\~{a}o','Interpreter','latex')
% figure(3)
% title('Frquencial: M\''{i}nimo','Interpreter','latex')
% figure(4)
% title('Frquencial: M\''{a}ximo','Interpreter','latex')
% figure(5)
% title('Frquencial: M\''{e}diana','Interpreter','latex')


%%% Analise frequencial resulta em observacao de padroes não significativos
%%% em relacao ao periodo anual, inclusive com alto grau de contamincao de
%%% ruido em todo o espectro. Padrão significavo encontrado apenas no
%%% gráfico dos valores mínimos.

close all
for i=1:5
    figure;
    subplot(1,2,1)
    histfit(Z(:,i))
    title('Histograma')
    grid
    subplot(1,2,2)
    probplot(Z(:,i))
    grid
end

figure(1)
s= suptitle('Hist. e Prob.: M\''{e}dia');
set(s,'Interpreter','latex')
figure(2)
s= suptitle('Hist. e Prob.: Desv. padr\~{a}o');
set(s,'Interpreter','latex')
figure(3)
s= suptitle('Hist. e Prob.: M\''{i}nimo');
set(s,'Interpreter','latex')
figure(4)
s= suptitle('Hist. e Prob.: M\''{a}ximo');
set(s,'Interpreter','latex')
figure(5)
s= suptitle('Hist. e Prob.: M\''{e}diana');
set(s,'Interpreter','latex')

%%% Por meio dos histogramas, pode-se observar que os valores mais altos
%%% obtidos nos anos de 2013 e 2012 distoam dos demais, conforme gaussiana.
%%% Indicativo de retirada, pelo menos do ano de 2013.

% close all
% for i=1:5
%     figure;
%     probplot(Z(:,i))
%     grid
% end



%%% Comparacao de probabilidade geral em acordo com os histogramas.

%%% Com base nas análises gráficas, concluo que uma média entre os meses
%%% com peso dois para o ano anterior e um para os demais, excluindo os
%%% dados do ano de 2012 e 2013, oferece uma boa estimativa para o ano seguinte.
Xa = X;
Za = Z;
save analise.mat Za Xa nP

%EOF