close all
clear all
clc

figure
plot(13,0.74,'o');hold on;
for ss = 12:-1:2
    ss_n = ss;
    max_trial = 0;
    Data    =  ReadData_sub('LCData',max_trial,ss_n);
    % fprintf('For first %d trials, we have %d samples\t',max_trial,Data.n);
    a       =  1;
    b       =  21;
    % See_min =  100;
    R2_max  =  0;
    % r2_max  =  0;
    % R2_max_comb = 0;
    R.s_min   = 0;
    R.d_min   = 0;
    % R.p_min   = 0;
    % R.par_min =[];

    for i=a:1:b  
        Model.ParIndex = [1 4];
        Model.s =  i;
        Model   =  CrossValidation(Data,Model);
    %     [see_min,j]  =  min(Model.See);
        [r2_max,j] =  max(Model.R_sq);

        if r2_max > R2_max
            R2_max = r2_max;
            R.s_min   = i;
            R.d_min   = j;
    %         R.p_min   = p;
    %         R.par_min = C(l,:);
        end
%              fprintf('%f \t %f\n',i,R2_max);
        warning off
    end
    R2_this_comb = R2_max;
    fprintf('sample size = %d\t',ss_n);
    fprintf('R2 = %f\t',R2_this_comb);
    fprintf('%d %d\n',R.s_min,R.d_min);
    plot(ss_n,R2_this_comb,'o-');hold on;
end
figure('rend','painters','pos',[150 150 220 200])
x = 2:13;
y = [0,0,0.068312,0,0,0,0,0,0,0.586508,0.553513,0.74];
h_plot = plot(x,y,'-.o');
set(h_plot                               ,...
    'LineStyle'         ,'-.'         ,...
    'LineWidth'         ,1.0            ,...
    'Marker'            ,'o'            ,...
    'MarkerSize'        , 4             ,...
    'MarkerEdgeColor'   ,[.2,.2,.2]            );
ylim([0 1])
xlim([5 13])
