load('No_plateau_initial.txt')
X                            =    No_plateau_initial;
clear No_plateau_initial;
[K,N]                       =       size(X);
Model.type                  =       'gaussian';
Model.n                     =       1;
Model.m                     =       7;
y_true = zeros(13,3);
y_pred = zeros(13,3);

Model.Sigma_KPCA            =       3;
Model.Sigma_KPLS            =       20;
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

% for all
y_true_all = reshape(y_true,[3*13,1]);
y_pred_all = reshape(y_pred,[3*13,1]);
SSE     = sum((y_pred_all).^2);
SST     = sum((y_true_all - mean(y_true_all)).^2);
R2      = 1 - SSE/SST;
fprintf('for all: SSE = %.2f; SST = %.2f; R2 = %.2f\n', SSE,SST,R2)
% for plateau level:
y_true1 = y_true(:,1);
y_pred1 = y_pred(:,1);
SSE     = sum((y_pred1).^2);
SST     = sum((y_true1 - mean(y_pred1)).^2);
R2      = 1 - SSE/SST;
fprintf('for plateau level: SSE = %.2f; SST = %.2f; R2 = %.2f\n', SSE,SST,R2)

% for trials number:
y_true2 = y_true(:,2);
y_pred2 = y_pred(:,2);
SSE     = sum((y_pred2).^2);
SST     = sum((y_true2 - mean(y_pred2)).^2);
R2      = 1 - SSE/SST;
fprintf('for trials number: SSE = %.2f; SST = %.2f; R2 = %.2f\n', SSE,SST,R2)

% for initial proficiency level:
y_true3 = y_true(:,3);
y_pred3 = y_pred(:,3);
SSE     = sum((y_pred3).^2);
SST     = sum((y_true3 - mean(y_pred3)).^2);
R2      = 1 - SSE/SST;
fprintf('for initial proficiency level: SSE = %.2f; SST = %.2f; R2 = %.2f\n', SSE,SST,R2)