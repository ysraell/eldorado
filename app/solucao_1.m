clear all
close all
clc

%%% Pre-formatacao
%%% cat data.csv |sed -e 's/\,/\./g' |sed -e 's/NA/nan/g' >data_mod.csv

data = importdata('data_mod.csv');

alvo = data(:,1);
mes = data(:,3);
ano = data(:,4);

%%% Para as linhas nas quais algo ~= NaN, replica linha anterior nos casos de
%%% NaN para o mês e ano.

T = size(data,1);
Y = zeros(sum(~isnan(alvo)),3);
s=1;
Y(1,:) = [alvo(1) mes(1) ano(1)];
for i=2:T
    if ~isnan(alvo(i))
        if isnan(mes(i))
            mes(i) = mes(i-1);
        end
        if isnan(ano(i))
            ano(i) = ano(i-1);
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
anos = [2007:2011 2014:2017]';
Ta = size(anos,1);
meses = [1:12]';
Tb = size(meses,1);
nP = 5;
X = zeros(Tb,nP);

for i=1:Tb
%     disp(meses(i))
    clear tmp
    tmp = [];
    for j=1:Ta
%         disp(anos(j))
        a = (anos(j)==Y(:,3));
        b = (meses(i)==Y(:,2));
        clear tmpa
        tmpa = zeros(sum(a.*b),1);
        k=0;
        for s=1:Ts
            if (anos(j)==Y(s,3))&&(meses(i)==Y(s,2))
                k=k+1;
                tmpa(k) = Y(s,1);
            end
        end
        tmp = [tmp; tmpa];
    end
    
    X(i,1) = mean(tmp);
    X(i,2) = std(tmp);
    X(i,3) = min(tmp);
    X(i,4) = max(tmp);
    X(i,5) = median(tmp);
    
end

Xm = mean(X(:,1)).*ones(Tb,1);

LW = 2;
figure;
hold on
plot(X(:,3),'c--','LineWidth',LW)
plot(X(:,4),'r--','LineWidth',LW)
errorbar(X(:,1),X(:,2),'xg--','LineWidth',LW)
plot(X(:,1),'LineWidth',LW)
plot(Xm,'k.-','LineWidth',LW)
lgd = legend('mim','max','desvio','m\''{e}dia mensal','m\''{e}dia anual');
set(lgd,'Interpreter','latex')
xlabel('meses')
ylabel('Alvo')
title('Prev. 2018')
grid
hold off

load analise

% Unindo os dados da analise e da solucao
Zt = [Za; X];
Xt = zeros(12,12,5);
for i=1:nP
    Xt(:,:,i) = [Xa(:,:,i) X(:,i)];
end
anos = [2007:2018]';


for i=1:5
    figure;
%     contourf(anos(:,1),meses(:,1),X(:,:,i))
    imagesc(anos(:,1),meses(:,1),Xt(:,:,i))
    contourcbar
    ylabel('meses')
    xlabel('anos')
    zlabel('Alvo')
end
figure(2)
title('M\''{e}dia','Interpreter','latex')
figure;
hold on
%plot(Z(:,5),'g.-')
plot(Zt(:,3),'k--')
plot(Zt(:,4),'r--')
errorbar(Zt(:,1),Zt(:,2),'xg--')
plot(Zt(:,1))
lgd = legend('mim','max','desvio','m\''{e}dia');
set(lgd,'Interpreter','latex')
ylabel('alvo')
xlabel('tempo (meses)')
title('S\''{e}rie hist\''{o}rica','Interpreter','latex')
grid
hold off



