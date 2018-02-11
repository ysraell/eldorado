clear all
close all
clc

%%% Pre-formatacao
%%% cat data.csv |sed -e 's/\,/\./g' |sed -e 's/NA/nan/g' >data_mod.csv
% 
% data = importdata('data_mod.csv');
% 
% alvo = data(:,1);
% hora = data(:,2);
% mes = data(:,3);
% ano = data(:,4);
% entradas = data(:,5:end);

% for i=1:T
%     figure;
%     histfit(entradas(:,i))
% end

% [I,J] = size(entradas);
% entradas0 = entradas;
% for i=2:I
%     for j=1:J
%         if isnan(entradas(i,j))
%             entradas(i,j)=entradas(i-1,j);
%         end
%     end
% end
        
% save data_analise2.mat

load data_analise2.mat

T = size(entradas,2);
for i=1:T
    figure;
    plot(entradas(:,i))
    set(gcf, 'Position', get(0, 'Screensize'));
    pause
end



for i=1:T
    figure;
    periodogram(entradas(:,i),'power');figure(gcf)
end

