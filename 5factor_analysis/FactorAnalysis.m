clc
close all
clear all

load('No_plateau_initial.txt')
X                            =    No_plateau_initial;
clear No_plateau_initial;
[K,N]                        =    size(X);
Model.type                   =    'gaussian';
Model.n                      =    1;
Model.m                      =    7;
MinVarE                      =    100;                    
See                          =    zeros(1,K);
for k=1:K
    if k == 1
        Xtrain               =    X(2:K,:);
    elseif k==K
        Xtrain               =    X(1:K-1,:);
    else
        Xtrain               =    [X(1:k-1,:);X(k+1:K,:)];
    end
    xtest                    =    X(k,:);
    xmean                    =    mean(Xtrain);
    xstd                     =    std(Xtrain);
    X0                       =    (Xtrain - ones(K-1,1)*xmean)/diag(xstd);
    x0                       =    (xtest - xmean)/diag(xstd);
    Sxx                      =    cov(X0);
    [P,S,~]                  =    svd(Sxx);
    p                        =    P(:,1);
    See(k)                   =    x0*(eye(3) - p*p')*x0';
end
fprintf('PCA Error is : %f\n',sum(See)/(K*N));
delta                        =    0.1;
E                            =    zeros(k,length(0.5:delta:30));
for Sigma_KPCA = 12:delta:14
    Model.Sigma_KPCA         =    Sigma_KPCA;
    for k=1:K
        if k == 1
            Xtrain           =    X(2:K,:);
        elseif k==K
            Xtrain           =    X(1:K-1,:);
        else
            Xtrain           =    [X(1:k-1,:);X(k+1:K,:)];
        end
        xtest                =    X(k,:);
        xmean                =    mean(Xtrain);
        xstd                 =    std(Xtrain);
        X0                   =    (Xtrain - ones(K-1,1)*xmean)/diag(xstd);
        x0                   =    (xtest - xmean)/diag(xstd);
        Model                =    KPCA(X0,Model);
        Model                =    ApplyKPCAModel(X0,x0,Model);
        t0                   =    Model.t;
        T0                   =    Model.T;
        m                    =    0;
        for Sigma_KPLS = 0.5:delta:30;
            m                =    m + 1;
            Model.Sigma_KPLS =    Sigma_KPLS;
            Model            =    KPLS(T0,X0,Model);
            Model            =    ApplyKPLSModel(T0,t0,Model);
            e                =    x0 - Model.xpred;
            E(k,m)           =    e*e';
        end
    end
    VarE                     =    min(sum(E));
    m                        =    find(sum(E) == VarE);
    if VarE < MinVarE
        MinVarE = VarE;
        Opt_Sigma_KPCA       =    Sigma_KPCA;
        Opt_Sigma_KPLS       =    (m-1)*delta+0.5;
    end
    fprintf('%f \t %f \t %f \t %f\n',Sigma_KPCA,Opt_Sigma_KPCA,Opt_Sigma_KPLS,MinVarE/(K*N));
end
