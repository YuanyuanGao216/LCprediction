load('No_plateau_initial.txt')
X                            =    No_plateau_initial;
clear No_plateau_initial;
[K,N]                       =       size(X);
Model.type                  =       'gaussian';
Model.n                     =       1;
Model.m                     =       7;
y_true = zeros(13,3);
y_pred = zeros(13,3);
max_R2 = -100000;
best_Sigma_KPLS = 0;
best_Sigma_KPCA = 0;
for Sigma_KPCA = 1:1:20
    for Sigma_KPLS = 1:1:20
        Model.Sigma_KPCA            =       Sigma_KPCA;
        Model.Sigma_KPLS            =       Sigma_KPLS;
        xmean                       =       mean(X);
        xstd                        =       std(X);
        X0                          =       (X-ones(K,1)*xmean)/diag(xstd);
        Model                       =       KPCA(X0,Model);
        T0                          =       Model.T;
        Model.Sigma_KPLS            =       Sigma_KPLS;
        Model                       =       KPLS(T0,X0,Model);
        Model                       =       ApplyKPLSModel(T0,T0,Model);
        e                           =       X0 - Model.Ypred;
        e_all   = reshape(e,[3*13,1]);
        y_all   = reshape(X0,[3*13,1]);
        SSE     = e_all'*e_all;
        SST     = sum((y_all - mean(y_all)).^2);
        R2_all      = 1 - SSE/SST;
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
            Model            =    KPLS(T0,X0,Model);
            Model            =    ApplyKPLSModel(T0,t0,Model);
            y_true(k,:) = x0;
            y_pred(k,:) = Model.xpred;
        end
        y_true_all = reshape(y_true,[3*13,1]);
        y_pred_all = reshape(y_pred,[3*13,1]);
        SSE     = sum((y_pred_all).^2);
        SST     = sum((y_true_all - mean(y_true_all)).^2);
        R2_CV      = 1 - SSE/SST;
        R2 = 0.5*R2_CV + 0.5*R2_all;
        if R2 > max_R2
            max_R2 = R2;
            best_Sigma_KPLS = Sigma_KPLS;
            best_Sigma_KPCA = Sigma_KPCA;
        end
    end
end
fprintf('best KPLS sigma = %d; KPCA: %.2f;R2 is %.2f\n',best_Sigma_KPLS,best_Sigma_KPCA,max_R2)