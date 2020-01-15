
clear all
intvl   =   [1,40;1,20;1,30;1,35;10,35;15,35;10,40];
l_intvl =   size(intvl,1);
fprintf('interval\tR2\tKP\tLV\n');
for k = 1:l_intvl
    v_start = intvl(k,1);
    v_end   = intvl(k,2);
    max_trial = 0;
    Data    =   ReadData('LCData',max_trial);
    X       =   Data.X(:,v_start:v_end);
%     X       =   Data.X(:,[1 4]);
    Y       =   Data.Y;

    %%
    case1_x = X(1:4,:);%FLS PC
    case1_y = Y(1:4,:);
    case2_x = X(5:10,:);%VB PC
    case2_y = Y(5:10,:);
    case3_x = X(11:13,:);%VB PC
    case3_y = Y(11:13,:);
    
%     %%train on FLS test on VB
%     fprintf('train on FLS test on VB\n')
%     Xtrain   = case1_x;
%     Ytrain   = case1_y;
%     xtest  = [case2_x;case3_x];
%     ytest  = [case2_y;case3_y];
%     [n_train N]   = size(Xtrain);
%     [n_test N]    = size(xtest);
    %%train on VB test on FLS
%     fprintf('train on FLS test on VB\n')
    xtest   = case1_x;
    ytest   = case1_y;
    Xtrain  = [case2_x;case3_x];
    Ytrain  = [case2_y;case3_y];
    [n_train N]   = size(Xtrain);
    [n_test N]    = size(xtest);
    %% 
    xmean      =  mean(Xtrain);
    ymean      =  mean(Ytrain);
    ystd       =  std(Ytrain);
    xstd       =  std(Xtrain);
    
    X0         =  (Xtrain - ones(n_train,1)*xmean)/diag(xstd);
    Y0         =  (Ytrain - ones(n_train,1)*ymean)/diag(ystd);
    x0         =  (xtest  - ones(n_test,1)*xmean)/diag(xstd);
    y0         =  (ytest  - ones(n_test,1)*ymean)/diag(ystd);
    
    X0(isnan(X0)) = 0;
    Y0(isnan(Y0)) = 0;
    x0(isnan(x0)) = 0;
    y0(isnan(y0)) = 0;
    X0(~isfinite(X0)) = 0;
    Y0(~isfinite(Y0)) = 0;
    x0(~isfinite(x0)) = 0;
    y0(~isfinite(y0)) = 0;
    alpha      =  1;
    Kernel.type =  'RBF_kernel';
    R_sq = 0;
    kernel_par = 0;
    L_var = 0;
%     fprintf('interval\tR2\tKP\tLV\n');
    warning off
    for i = .1:.1:1000
% for i = 1:1:100
        Kernel.s    =  i;
        for j = 1:15
            Model      =   KPLS(X0,Y0,j,Kernel);
%             warning off;
            ypred      =   ApplyKPLSModel(X0,x0,Kernel,Model);
            See        =  sum((y0 - ypred).^2)/n_test;
            Sst        =  sum((y0 - mean(y0)).^2)/n_test;
            R_sq_TE    =  1 - See/Sst;
            R_sq_TR    =  Model.R2;
            R_sq_comb  =  (alpha*R_sq_TE+(1-alpha)*R_sq_TR);
%             R_sq_comb  =  Model.R2;
            if R_sq_comb > R_sq
                R_sq = R_sq_comb;
                kernel_par = i;
                L_var = j;
            end
        end
    end
    fprintf('%d:%d\t%.2f\t%d\t%d\n', v_start,v_end,R_sq,kernel_par,L_var)
end
%% 
% figure
% for i = 1:n_train
%    plot(1:Data.N, Data.X(i+7,:),'b-')
%    hold on
% end
% for i = 1:n_test
%    plot(1:Data.N, Data.X(i,:),'r-')
%    hold on
% end
